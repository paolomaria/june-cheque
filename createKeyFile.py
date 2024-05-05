import argparse
from duniterpy.key import SigningKey
from silkaj.public_key import gen_pubkey_checksum

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Optional app description')
    parser.add_argument('indentifier')
    parser.add_argument('password')
    parser.add_argument('filename')
    args = parser.parse_args()
	
    key = SigningKey.from_credentials(args.indentifier, args.password)
    key.save_seedhex_file(args.filename)

