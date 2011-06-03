# ======================================================================================= 
#                   _   _
#   _ __ ___  _   _| |_| |_ _ __ ___
#  | '_ ` _ \| | | | __| __| '__/ __|
#  | | | | | | |_| | |_| |_| | | (__
#  |_| |_| |_|\__,_|\__|\__|_|  \___|
#
# ---------------------------------------------------------------------------------------
# NOTE: name i desc sluze za muttprofile
# NAME: aceofknaves
# DESC: [ aceofknaves@gmail.com        ]
# =======================================================================================

# prvo ucitam default podesavanja
  source "~/.mutt/sourced/profiles/default"

# === aceofknaves@gmail.com =============================================================

# --- Aliases ---------------------------------------------------------------------------
  alias me      Ђорђе Тодоровић <aceofknaves@gmail.com>
  alias razmena razmenavestina@googlegroups.com <razmenavestina@googlegroups.com> 

# === SEND-HOOKS ========================================================================

# --- Default ---------------------------------------------------------------------------
# set signature = "~/.mutt/bin/signature |"; \

send-hook '.*' ' \
    set from = "Ђорђе Тодоровић <aceofknaves@gmail.com>"; \
    set envelope_from_address = "Ђорђе Тодоровић <aceofknaves@gmail.com>"; \
    set realname = "Ђорђе Тодоровић--"; \
    set signature = "~/.mutt/signatures/djordje-ascii"; \
    unmy_hdr *; \
    my_hdr X-PGP-Key: "http://pastebin.com/nGxFm4SJ"; \
    my_hdr Return-Path: "Ђорђе Тодоровић <aceofknaves@gmail.com>"; \
    my_hdr X-Original-Sender: "Ђорђе Тодоровић <aceofknaves@gmail.com>"'

# --- Mailing-lists) --------------------------------------------------------------------
  send-hook '~C ^razmenavestina@googlegroups\.com$' ' \
    my_hdr Reply-To: razmenavestina@googlegroups.com; \
    my_hdr Sender: razmenavestina@googlegroups.com; \
    my_hdr Mailing-list: list razmenavestina@googlegroups.com\; contact razmenavestina+owners@googlegroups.com; \
    my_hdr List-ID: <razmenavestina.googlegroups.com>; \
    my_hdr List-Archive: <http://groups.google.com/group/razmenavestina?hl=en_US>; \
    my_hdr List-Unsubscribe: <http://groups.google.com/group/razmenavestina/subscribe?hl=en_US>, <mailto:razmenavestina+unsubscribe@googlegroups.com>; \
    my_hdr X-Google-Group-Id: 32278324701; \
    my_hdr Precedence: list'

# =======================================================================================

# --- Crypto stuff ----------------------------------------------------------------------
  set pgp_encrypt_only_command = "pgpewrap gpg --batch --quiet --no-verbose --output - --encrypt --textmode --armor --always-trust --encrypt-to 0x1E133339 -- -r %r -- %f"
  set pgp_encrypt_sign_command = "pgpewrap gpg --passphrase-fd 0 --batch --quiet --no-verbose --textmode --output - --encrypt --sign %?a?-u %a? --armor --always-trust --encrypt-to 0x1E133339 -- -r %r -- %f"
  set pgp_sign_as = "0x1E133339"      # UserID/KeyID for signing

  set pgp_autoencrypt = no               # Default (no enc)
  set pgp_autosign = no                  # Default (no sign)

# --- Folderi ---------------------------------------------------------------------------
  set folder = "~/.Mail/mailboxes/[Gmail] aceofknaves/"
  set record = "~/.Mail/mailboxes/[Gmail] aceofknaves/Sent Mail"
  set postponed = "~/.Mail/mailboxes/[Gmail] aceofknaves/Drafts"

# --- IMAP settings ---------------------------------------------------------------------
  set imap_user = aceofknaves@gmail.com

# --- SMTP ------------------------------------------------------------------------------
  set sendmail = "/usr/bin/msmtp -a aceofknaves"

# kada je smtp_url unset, koristimo sendmail za slanje i pass iz config fajla 
# kada je smtp_url set, koristimo njega za slanje a smtp_pass se onda koristi
# BTW: smtp_url je set kada se ulogujemo na server, namesta ga account-hook, ovde je pass
  unset smtp_url

# --- Makros ----------------------------------------------------------------------------
  macro index,pager,compose ,1 "<edit-from><kill-line>Ђорђе Тодоровић <aceofknaves@gmail.com><enter>" "From: Ђорђе Тодоровић <aceofknaves@gmail.com>"
  macro index,pager,compose ,2 "<edit-from><kill-line>Đorđe Todorović <aceofknaves@gmail.com><enter>" "From: Đorđe Todorović <aceofknaves@gmail.com>"
  macro index,pager,compose ,3 "<edit-from><kill-line>Ђорђе <aceofknaves@gmail.com><enter>" "From: Ђорђе <aceofknaves@gmail.com>"
  macro index,pager,compose ,4 "<edit-from><kill-line>Barabbas <aceofknaves@gmail.com><enter>" "From: Barabbas <aceofknaves@gmail.com>"
  macro index,pager,compose ,5 "<edit-from><kill-line>aceofknaves <aceofknaves@gmail.com><enter>" "From: aceofknaves <aceofknaves@gmail.com>"
  macro index,pager,compose ,6 "<edit-from><kill-line><aceofknaves@gmail.com><enter>" "From:<aceofknaves@gmail.com>"

# =======================================================================================
