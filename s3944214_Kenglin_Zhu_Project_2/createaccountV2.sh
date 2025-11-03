#!/bin/bash
# =================== Code Inspection (for createaccount.sh) ===================
# Inspector Name : Kenglin Zhu
# Inspection Date: 2025-11-03
# Total Errors   : 4
# 1) Category: Syntax/Typo
#    Desc : Used "User@dd" instead of "useradd".
#    Fix  : Replace with correct command "useradd".
# 2) Category: Wrong command usage
#    Desc : Used "passwd $pwrd" to set password; passwd is interactive.
#    Fix  : Use: echo "user:pass" | chpasswd
# 3) Category: Missing privileges
#    Desc : Script ran without root; useradd/chpasswd need elevated rights.
#    Fix  : Check EUID and require sudo/root.
# 4) Category: Missing input/logic
#    Desc : No role/group handling; users not assigned to groups.
#    Fix  : Ask role (students/teachers); ensure group exists; add user to group.
# ============================================================================

set -e

# must be root (or run via: sudo ./createaccountV2.sh)
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (use: sudo ./createaccountV2.sh)"
  exit 1
fi

read -rp "Enter username: " USERNAME
if [[ -z "$USERNAME" ]]; then
  echo "Username cannot be empty."; exit 1
fi
if id -u "$USERNAME" >/dev/null 2>&1; then
  echo "User '$USERNAME' already exists."; exit 1
fi

read -rp "Enter full name (comment): " FULLNAME

read -rp "Enter role (students/teachers): " ROLE
ROLE=$(echo "$ROLE" | tr 'A-Z' 'a-z')
if [[ "$ROLE" != "students" && "$ROLE" != "teachers" ]]; then
  echo "Invalid role. Must be 'students' or 'teachers'."; exit 1
fi

# ensure target group exists
getent group "$ROLE" >/dev/null 2>&1 || groupadd "$ROLE"

# read password silently
read -rsp "Enter initial password: " PASSWORD; echo
if [[ -z "$PASSWORD" ]]; then
  echo "Password cannot be empty."; exit 1
fi

# create user and set password
useradd -m -s /bin/bash -c "$FULLNAME" "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# assign to role group
usermod -aG "$ROLE" "$USERNAME"

echo "OK: created user '$USERNAME' and added to group '$ROLE'."
