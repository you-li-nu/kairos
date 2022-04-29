import sys
from module import Io
from wrapper import Wrapper

def main():
    assert len(sys.argv) == 4, 'python3 kairos.py fast.v slow.v dest.v'
    print(' '.join(sys.argv))
    w = Wrapper(sys.argv[1], sys.argv[2], sys.argv[3])
    w.wrap()

if __name__ == "__main__":
    main()
