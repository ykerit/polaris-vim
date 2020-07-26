import sys

def version_check():
    version = sys.version[:3]
    if (int(version[0]) >= 3 and int(version[2]) >=6):
        sys.exit(0)
    sys.exit(1)

if __name__ == '__main__':
    version_check()
