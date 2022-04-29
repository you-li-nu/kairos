import copy
from module import Io, Port


class Wrapper:
    def __init__(self, fast, slow, dest : str) -> None:
        self.fast = fast
        self.slow = slow
        self.dest = dest
        self.io = Io(fast, slow)
        self.ports = {}
        self.ret = ''

        
    def wrap(self) -> None:
        self.copy_file(self.fast)
        self.copy_file(self.slow)
        self.gen_module_params()
        self.gen_declarations()
        self.gen_assignments()
        self.gen_instantiations()
        self.ret += 'endmodule'
        self.write_file(self.dest)
        
    def copy_file(self, file : str) -> None:
        with open(file, 'r') as f:
            self.ret += f.read()
            self.ret += '\n\n'
            
    def gen_module_params(self) -> None: # special signals: clk, reset, valid (out)
        params = copy.deepcopy(self.io.params)
        for _, v in self.io.ports.items():
            if v.type.startswith('output'):
                params.remove(v.name)
        params.append('nequiv')
        p = ','.join(params)
        name = self.dest[: self.dest.index('.')]
        self.ret += f'module {name} ({p});\n'
        
    def gen_declarations(self) -> None:
        for k, v in self.io.ports.items():
            if v.type == 'input' and v.name != 'clk':
                self.ports[k] = v
            elif v.type.startswith('output'):
                self.ports[v.name + '_1'] = Port('wire', v.msb, v.name + '_1')
                self.ports[v.name + '_2'] = Port('wire', v.msb, v.name + '_2')
            elif v.name == 'clk':
                self.ports[k] = v
                self.ports[v.name + '_1'] = Port('wire', v.msb, v.name + '_1')
                self.ports[v.name + '_2'] = Port('wire', v.msb, v.name + '_2')
                
        self.ports['clk_en_1'] = Port('wire', 0, 'clk_en_1')
        self.ports['clk_en_2'] = Port('wire', 0, 'clk_en_2')
        self.ports['nequiv'] = Port('output', 0, 'nequiv')
                
        for _, v in self.ports.items():
            self.ret += f'\t{v};\n'
        self.ret += '\n'
            
    def gen_instantiations(self) -> None:
        self.ret += f'\t{self.io.fast_name} fast_m (\n'
        for k, v in self.io.ports.items():
            if v.type == 'input' and v.name != 'clk':
                self.ret += f'\t\t.{v.name}({v.name}),\n'
            elif v.type.startswith('output') or v.name == 'clk':
                self.ret += f'\t\t.{v.name}({v.name}_1),\n'
        if self.ret.endswith(',\n'):
            self.ret = self.ret[:-2] + '\n'
        self.ret += f'\t);\n'
        self.ret += '\n'
        
        self.ret += f'\t{self.io.slow_name} slow_m (\n'
        for k, v in self.io.ports.items():
            if v.type == 'input' and v.name != 'clk':
                self.ret += f'\t\t.{v.name}({v.name}),\n'
            elif v.type.startswith('output') or v.name == 'clk':
                self.ret += f'\t\t.{v.name}({v.name}_2),\n'
        if self.ret.endswith(',\n'):
            self.ret = self.ret[:-2] + '\n'
        self.ret += f'\t);\n'
        self.ret += '\n'
        
    def gen_assignments(self) -> None:
        self.assign_clk_en()
        self.clock_gating()
        self.assign_equiv()
        
    def assign_clk_en(self) -> None:
        self.ret += f'\tassign clk_en_1 = ~(valid_1 & ~ valid_2);\n'
        self.ret += f'\n'
        self.ret += f'\tassign clk_en_2 = ~(valid_2 & ~ valid_1);\n'
        self.ret += f'\n'
        
    def clock_gating(self) -> None:
        self.ret += f'\tassign clk_1 = clk & clk_en_1;\n'
        self.ret += f'\n'
        self.ret += f'\tassign clk_2 = clk & clk_en_2;\n'
        self.ret += f'\n'
        
    def assign_equiv(self) -> None:
        comp = []
        for k, v in self.io.ports.items():
            if v.type.startswith('output') and not v.name.startswith('valid'):
                comp.append(f'{v.name}_1 == {v.name}_2')
        comparison = ' & '.join(comp)
        self.ret += f'\tassign nequiv = ~(~valid_1 | ~valid_2 | {comparison});\n'
        self.ret += f'\n'
            
    def write_file(self, dest) -> None:
        with open(dest, 'w') as f:
            f.write(self.ret)