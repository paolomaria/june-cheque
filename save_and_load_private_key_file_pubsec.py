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
import os
import argparse

from duniterpy.key import SigningKey



if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Optional app description')
    parser.add_argument('indentifier')
    parser.add_argument('password')
    parser.add_argument('output')
    args = parser.parse_args()

    salt = args.indentifier
    password = args.password

    signer = SigningKey.from_credentials(salt, password)

    signer.save_pubsec_file(args.output)

    # document saved
    print(
        f"Private key for public key {signer.pubkey} saved in {args.output}"
    )

