# ======================================================================================= 
#                   _   _
#   _ __ ___  _   _| |_| |_ _ __ ___
#  | '_ ` _ \| | | | __| __| '__/ __|
#  | | | | | | |_| | |_| |_| | | (__
#  |_| |_| |_|\__,_|\__|\__|_|  \___|
#
# ---------------------------------------------------------------------------------------
# NOTE: name i desc sluze za muttprofile
# NAME: postmanmiler
# DESC: [ postmanmiler@gmail.com       ]
# =======================================================================================

# prvo ucitam default podesavanja
  source "~/.mutt/sourced/profiles/default"

# === postmanmiler@gmail.com =============================================================

# --- Aliases ---------------------------------------------------------------------------
  alias me        Ђорђе Тодоровић <postmanmiler@gmail.com>

# --- Headers and personal info ---------------------------------------------------------
  set from = "Ђорђе Тодоровић <postmanmiler@gmail.com>"
  set envelope_from_address  = "<postmanmiler@gmail.com>"
  set realname = "Ђорђе Тодоровић--"
# set signature = "~/.mutt/bin/signature |"
  set signature = "~/.mutt/signatures/djordje-ascii"

  my_hdr X-PGP-Key: http://pastebin.com/nGxFm4SJ

# --- Crypto stuff ----------------------------------------------------------------------
  set pgp_encrypt_only_command = "pgpewrap gpg --batch --quiet --no-verbose --output - --encrypt --textmode --armor --always-trust --encrypt-to 0x1E133339 -- -r %r -- %f"
  set pgp_encrypt_sign_command = "pgpewrap gpg --passphrase-fd 0 --batch --quiet --no-verbose --textmode --output - --encrypt --sign %?a?-u %a? --armor --always-trust --encrypt-to 0x1E133339 -- -r %r -- %f"
  set pgp_sign_as = "0x1E133339"         # UserID/KeyID for signing

  set pgp_autoencrypt = no               # Default (no enc)
  set pgp_autosign = no                  # Default (no sign)

# --- Folderi ---------------------------------------------------------------------------
  set folder = "~/.Mail/mailboxes/[Gmail] postmanmiler/"
  set record = "~/.Mail/mailboxes/[Gmail] postmanmiler/Sent Mail"
  set postponed = "~/.Mail/mailboxes/[Gmail] postmanmiler/Drafts"

# --- IMAP settings ---------------------------------------------------------------------
  set imap_user = postmanmiler@gmail.com

# --- SMTP ------------------------------------------------------------------------------
  set sendmail = "/usr/bin/msmtp -a postmanmiler"

# --- Makros ----------------------------------------------------------------------------
  macro index,pager,compose ,1 "<edit-from><kill-line>Ђорђе Тодоровић <postmanmiler@gmail.com><enter>" "From: Ђорђе Тодоровић <postmanmiler@gmail.com>"
  macro index,pager,compose ,2 "<edit-from><kill-line>Đorđe Todorović <postmanmiler@gmail.com><enter>" "From: Đorđe Todorović <postmanmiler@gmail.com>"
  macro index,pager,compose ,3 "<edit-from><kill-line>Ђорђе <postmanmiler@gmail.com><enter>" "From: Ђорђе <postmanmiler@gmail.com>"
  macro index,pager,compose ,4 "<edit-from><kill-line>Postman Miler <postmanmiler@gmail.com><enter>" "From: Barabbas <postmanmiler@gmail.com>"
  macro index,pager,compose ,5 "<edit-from><kill-line>postmanmiler <postmanmiler@gmail.com><enter>" "From: postmanmiler <postmanmiler@gmail.com>"
  macro index,pager,compose ,6 "<edit-from><kill-line><postmanmiler@gmail.com><enter>" "From:<postmanmiler@gmail.com>"

# =======================================================================================
