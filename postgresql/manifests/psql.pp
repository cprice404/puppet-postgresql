# puppet-postgresql
# For all details and documentation:
# http://github.com/inkling/puppet-postgresql
#
# Copyright 2012- Inkling Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

define postgresql::psql($command = $title, $unless, $db, $user = 'postgres', $version='9.1') {

  # FIXME: shellquote does not work, and this regex works for trivial things but not nested escaping.
  # Need a lexer, preferably a ruby SQL parser to catch errors at catalog time
  # Possibly https://github.com/omghax/sql ?

  $psql = "/usr/lib/postgresql/$version/bin/psql --no-password --tuples-only --quiet --dbname $db"
  $quoted_command = regsubst($command, '"', '\\"')
  $quoted_unless  = regsubst($unless,  '"', '\\"')

  exec {"/bin/echo \"$quoted_command\" | $psql":
    unless  => "/bin/echo \"$quoted_$unless\" | $psql | egrep -v -q '^$'",
    user    => $user,
  }
}

