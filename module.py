from typing import List, Tuple

class Port:
    def __init__(self, type, msb, name) -> None:
        self.type : str = type
        self.msb : int = int(msb) # msb = 0 if it has a width of 1.
        self.name : str = name
        
    def __str__(self) -> str:
        lst = [self.type]
        if self.msb != 0:
            lst.append(f'[{self.msb}:0]')
        lst.append(self.name)
        
        return ' '.join(lst)

class Io:
    def __init__(self, fast, slow) -> None:
        fast_ports : dict[str, Port] = self.process_declaration(fast)
        slow_ports : dict[str, Port] = self.process_declaration(slow)        
            
        assert fast_ports.keys() == slow_ports.keys(), 'I/O inconsistent.'
        self.ports = fast_ports
        self.fast_name, fast_params = self.process_name_params(fast)
        self.slow_name, slow_params = self.process_name_params(slow)
        assert fast_params == slow_params, 'params inconsistent.'
        assert set(fast_params) == set(self.ports), 'params not consistent to ports.'
        self.params = fast_params
        assert 'clk' in self.params, 'missing clk.'
        assert 'valid' in self.params, 'missing valid.'
        print(self)
        
    def print_module(self, name) -> str:
        p = ', '.join(self.params)
        ret = f'module {name} ({p});\n'
        return ret
        
    def print_declaration(self) -> str:
        ret = ''
        for _, v in self.ports.items():
            ret += f'\t{v};\n'
        return ret
            
    def __str__(self) -> str:
        ret = ''
        ret += self.print_module(self.fast_name)
        ret += self.print_declaration()
        return ret
    
    def process_name_params(self, file) -> Tuple[str, List[str]]:
        name = ''
        params = []
        with open(file, 'r') as f:
            for line in f.readlines():
                if line.startswith('module'):
                    name =  line.strip().split()[1]
                    for p in line[line.index('(') + 1 : line.rindex(')')].strip().split(','):
                        params.append(p.strip())
        return name, params
        
    def process_declaration(self, file) -> dict:
        ports = {}
        with open(file, 'r') as f:
            for line in f.readlines():
                line = line.strip()
                if line.startswith('input') or line.startswith('output') or line.startswith('inout'):
                    lst = line.split()
                    for i in range(len(lst)):
                        lst[i] = lst[i].strip(';')
                    typ = lst[0]
                    if 'reg' in lst:
                        typ += ' reg'
                        lst.remove('reg')
                    for n in lst[-1].split(','):
                        if len(lst) == 2:
                            ports[n] = Port(typ, 0, n)
                        elif len(lst) == 3:
                            ports[n] = Port(typ, lst[1][1:lst[1].index(':')], n)
        return ports