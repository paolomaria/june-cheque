# Copyright  2014-2022 Vincent Texier <vit@free.fr>
#
# DuniterPy is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# DuniterPy is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import getpass
import argparse
from duniterpy.key import SigningKey
from silkaj.public_key import gen_pubkey_checksum

################################################


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Optional app description')
    parser.add_argument('indentifier')
    parser.add_argument('password')
    args = parser.parse_args()
	
    key = SigningKey.from_credentials(args.indentifier, args.password)
    pubkey_cksum = gen_pubkey_checksum(key.pubkey)

    # Display your public key
    print(f"{pubkey_cksum}")
