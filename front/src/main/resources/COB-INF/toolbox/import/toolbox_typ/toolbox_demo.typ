\+DatabaseType SHLEX SAMPLE
\ver 4.0
\desc Uses Standard Format markers as defined in
_Making Dictionaries:
A guide to lexicography and
the Multi-Dictionary Formatter_.
David F. Coward, Charles E. Grimes, and
Mark Pedrotti.
Waxhaw, NC: SIL, 1998. (Version 2.0)
\+mkrset 
\lngDefault English
\mkrRecord lx

\+mkr a
\nam alternate form
\lng vernacular
\mkrOverThis lx
\-mkr

\+mkr an
\nam Antonym
\desc Used to reference an antonym of the lexeme, but using the \lf (lexical function) field for this is better practice.
\lng vernacular
\mkrOverThis sd
\CharStyle
\-mkr

\+mkr bb
\nam Bibliography
\desc Used to record any bibliographic information pertinent to the lexeme. MDF adds the label 'Read:' to this field.
\lng English
\mkrOverThis sc
\CharStyle
\-mkr

\+mkr bw
\nam Borrowed word (loan)
\desc Used for denoting  the source language of a borrowed word.
\lng English
\mkrOverThis bwdummy
\CharStyle
\-mkr

\+mkr bwdummy
\nam Borrowed word (loan) dummy value
\desc help to structure 
\lng English
\mkrOverThis lx
\CharStyle
\-mkr

\+mkr ce
\nam Cross-ref. gloss (E)
\desc Gives the English gloss(es) for the vernacular lexeme referenced by the preceding \cf field.
\lng English
\mkrOverThis cf
\CharStyle
\-mkr

\+mkr cf
\nam Cross-reference
\desc This is a generic reference marker used to link together any two related entries in the lexicon. The content is a vernacular lexeme. If the relationship is known, the lexical function \lf field is a better way to cross-reference two lexemes.
\lng vernacular
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr cn
\nam Cross-ref. gloss (n)
\desc Gives the national language gloss(es) for the vernacular lexeme referenced by the preceding \cf field.
\lng national
\mkrOverThis cf
\CharStyle
\-mkr

\+mkr de
\nam Definition (E)
\desc Used to fully express the semantic domains of each sense of a lexeme in English. May be verbose. Other fields (\ee, \ue, and \oe) provide for expanded information.
\lng English
\mkrOverThis gn
\CharStyle
\-mkr

\+mkr diaVardummy
\nam dialectal variant dummy
\desc help to strcuture 
\lng vernacular
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr diaVar
\nam dialectal variant
\desc Used for variants of other dialects in the language; the field marker \va expresses slight phonological variations of the same dialect (doublets or triplets).
\lng vernacular
\mkrOverThis diaVardummy
\CharStyle
\-mkr

\+mkr dn
\nam Definition (n)
\desc Used to fully express the semantic domains of each sense of a lexeme in the national language. May be verbose. Other fields (\en, \un, and \on) provide for expanded information.
\lng national
\mkrOverThis gn
\CharStyle
\-mkr

\+mkr dt
\nam Date (last edited)
\desc A Shoebox bookkeeping field to help keep track of the last time an entry was edited. One per record (usually the last field) is adequate. Usually inserted automatically by Shoebox. The datestamp field is set up under the Shoebox menu option: Database-Properties-Options tab.
\lng Date
\mkrOverThis dtdummy
\CharStyle
\-mkr

\+mkr dtdummy
\nam Date dummy value
\desc help to structure 
\lng English
\mkrOverThis lx
\CharStyle
\-mkr

\+mkr dv
\nam Definition (v)
\desc The hardest of all fields to fill in. It requires the researcher to explain, in the vernacular, what the salient concepts are that this "unit of meaning" captures -- from a native speaker's perspective. Obviously not easy and something usually left to much later.
\lng vernacular
\mkrOverThis gn
\CharStyle
\-mkr

\+mkr dvUP
\nam Definition (v)
\desc The hardest of all fields to fill in. It requires the researcher to explain, in the vernacular, what the salient concepts are that this "unit of meaning" captures -- from a native speaker's perspective. Obviously not easy and something usually left to much later.
\lng vernacular
\mkrOverThis gn
\CharStyle
\-mkr

\+mkr ec
\nam Etymology comment
\desc Any comments the researcher needs to add concerning the etymology of the lexeme can be given here.
\lng English
\mkrOverThis et
\CharStyle
\-mkr

\+mkr ee
\nam Encyclopedic info (E)
\desc This field crosses over with the \de, \ue, and \oe fields, but is intended for more verbose explanations of the headword (for each sense). The researcher should use this field to encode any  additional information needed by a non-native speaker to understand and use this lexeme properly.
\lng English
\mkrOverThis sc
\CharStyle
\-mkr

\+mkr eg
\nam Etymology gloss (E)
\desc The published gloss for the etymological reference is given here.
\lng English
\mkrOverThis et
\CharStyle
\-mkr

\+mkr egn
\nam etymology gloss nat. lang.
\lng English
\mkrOverThis et
\CharStyle
\-mkr

\+mkr en
\nam Encyclopedic info. (n)
\desc The national language equivalent to the \ee field. It should cover any information that provides a more complete knowledge-base on the lexeme.
\lng national
\mkrOverThis sc
\CharStyle
\-mkr

\+mkr et
\nam Etymology (proto form)
\desc The etymology for the lexeme is put here, e.g.: \et *babuy
\lng vernacular
\mkrOverThis lx
\CharStyle
\-mkr

\+mkr ev
\nam Encyclopedic info. (v)
\desc This field contains the vernacular description of any pertinent encyclopedic information related to the lexeme or headword, subentry, or sense. This is intended for use in a monolingual dictionary, but can be used in diglot and triglot dictionaries as well.
\lng vernacular
\mkrOverThis sc
\CharStyle
\-mkr

\+mkr ge
\nam Gloss (E)
\desc Intended for interlinear morpheme-level glossing. The contents are used for reversing the dictionary if an \re field is not present (or is present but empty). Also used as an English definition in a formatted dictionary if there is no \de field (or it is present but empty).
\lng English
\mkrOverThis gn
\CharStyle
\-mkr

\+mkr gn
\nam Gloss (n)
\desc Intended for interlinear morpheme-level glossing. The contents are used for reversing the dictionary if an \rn field is not present (or is present but empty). Also used as a national language definition in a formatted dictionary if there is no \dn field (or it is present but empty).
\lng national
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr ff
\nam attached file
\lng English
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr fn
\nam description attached file (n)
\lng English
\mkrOverThis ff
\-mkr

\+mkr fv
\nam description attached file (v)
\lng English
\mkrOverThis ff
\-mkr

\+mkr hm
\nam Homonym number 
\desc Used to differentiate homonym entries (lexemes that sound or are spelled the same but have no semantic relationship). This field comes directly after the \lx field and simply contains a number, e.g. 1, 2, or 3, etc.
\lng English
\mkrOverThis hmdummy
\CharStyle
\-mkr

\+mkr hmdummy
\nam homonym number dummy value
\desc help to structure 
\lng English
\mkrOverThis lx
\CharStyle
\-mkr

\+mkr hmdummy
\nam homonym number dummy value
\desc help to structure 
\lng English
\mkrOverThis se
\CharStyle
\-mkr

\+mkr lf
\nam Lexical function label
\desc Used to encode the semantic networks of a language. For consistency, a Range Set should be maintained on the lexical function labels used. When formatted by MDF, these labels can be modified (and even translated) by MDF's Audience CC tables.
\lng English
\+fnt 
\Name Times New Roman
\Size 11
\Italic
\rgbColor 0,0,0
\-fnt
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr ln
\nam Lexical function gloss (n)
\desc This is for giving the national language gloss of the vernacular lexeme referenced by the lexical function.
\lng national
\mkrOverThis lv
\CharStyle
\-mkr

\+mkr lv
\nam Lexical function value
\desc Used for the vernacular lexeme in a lexical function network. The \lv field "points to" the vernacular lexeme (a morpheme, word, or phrase) that is semantically related to the current headword as mapped or cataloged by the label in the \lf field.
\lng vernacular
\mkrOverThis lf
\CharStyle
\-mkr

\+mkr lx
\nam Lexeme
\desc The Record marker for each record in a lexical entry. It contains the lexeme or headword (which is commonly mono-morphemic). Since such a lexeme form is often not accessible for vernacular speakers if printed, use the \lc field to provide a more readable form for vernacular speakers.
\lng vernacular
\-mkr

\+mkr nt
\nam Notes (general)
\desc This is a generic dump for all your personal notes about an entry, subentry, or sense. More specific note fields are provided for those who desire a finer differentiation to their notes: \np (phonology); \ng (grammar); \nd (discourse); \na (anthropology); \ns (sociolinguistics); \nq (questions).
\lng English
\mkrOverThis so
\CharStyle
\-mkr

\+mkr nt-www
\nam link internet
\lng English
\mkrOverThis so
\CharStyle
\-mkr

\+mkr pc
\nam Picture
\desc This contains either the book and page number reference of a relevant picture (either sketched in a notebook or found in a picture book), or a link to the graphics file of a picture you want to include in your printed dictionary (see MDF documentation for how to create a link).
\lng English
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr pl
\nam Plural form
\desc This is a special paradigm field used to give the plural form of the lexeme. (It is better to use the \pdl field set for this.)
\lng vernacular
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr ps
\nam Part of speech
\desc Used to classify the part of speech for the vernacular lexeme (not the national or English gloss). Consistent labeling is important. Use the Range Set feature for this field.
\lng English
\rngset adj adv adv:tm disc id n n:an ph pos prep pro qmrk v vi vt 
\mkrOverThis lx
\CharStyle
\-mkr

\+mkr ps
\nam Part of speech
\desc Used to classify the part of speech for the vernacular lexeme (not the national or English gloss). Consistent labeling is important. Use the Range Set feature for this field.
\lng English
\rngset adj adv adv:tm disc id n n:an ph pos prep pro qmrk v vi vt 
\mkrOverThis se
\CharStyle
\-mkr

\+mkr re
\nam Reversal (E)
\desc Gives the English word or phrase to be use to reverse the dictionary for an English index. If no \re field is given, the \ge field is used. If an \re * is present, the relevant entry, subentry, or sense will not be included in the reversed index.
\lng English
\mkrOverThis gn
\CharStyle
\-mkr

\+mkr rf
\nam Reference
\desc Used to keep a notebook reference for the following example sentence.
\lng English
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr rn
\nam Reversal (n)
\desc Gives the national language word or phrase to be use to reverse the dictionary for a national audience index. If no \rn field is given, the \gn field is used. If an \rn * is present, the relevant entry, subentry, or sense will not be included in the reversed index.
\lng national
\mkrOverThis gn
\CharStyle
\-mkr

\+mkr sc
\nam Scientific name
\desc Used to provide a scientific name for a lexeme.
\lng English
\+fnt 
\Name Times New Roman
\Size 11
\Italic
\Underline
\rgbColor 0,0,0
\-fnt
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr sd
\nam Semantic domain
\desc The English version of the \th field and probably the one to use first. Try to catalog and differentiate the semantic compartments of an entry, being careful to not let the English force or mask the vernacular relations. Moving to the vernacular terms (given in \th field) as early as possible is best.
\lng English
\mkrOverThis sn
\CharStyle
\-mkr

\+mkr sdv
\nam semantic domain vernacular
\desc Used to indicate the semantic domain in the vernacular language.
\lng vernacular
\mkrOverThis sd
\CharStyle
\-mkr

\+mkr se
\nam Subentry
\desc This is like the \lx field except it occurs within the record, marking the word (or phrase) as a form derived from the root. Following this marker would be all the fields that comprise a typical lexical entry. There can be several of these subentries within a record. Subentries can have multiple senses (in this hierarchy).
\lng vernacular
\+fnt 
\Name Times New Roman
\Size 12
\Bold
\rgbColor 0,0,0
\-fnt
\mkrOverThis lx
\-mkr

\+mkr sfx
\nam *
\lng English
\mkrOverThis lx
\-mkr

\+mkr sn
\nam Sense number
\desc Where a lexeme has more than one sense, this code is used to number and mark the beginning of each section in the entry that discusses a new sense. In this hierarchy the sense is considered beneath both the subentry and the part of speech.
\lng English
\mkrOverThis ps
\CharStyle
\-mkr

\+mkr so
\nam Source
\desc Used to indicate the name and village of the informant who gave you the data in the current entry.
\lng English
\mkrOverThis lx
\CharStyle
\-mkr

\+mkr sy
\nam Synonym
\desc Used to reference a synonym of the lexeme, but using the \lf (lexical function) field for this is better practice.
\lng vernacular
\mkrOverThis sd
\CharStyle
\-mkr

\+mkr th
\nam Thesaurus
\desc Used for developing a vernacular-based thesaurus. It is to be labeled with the vernacular term governing the semantic domain of the entry. Indexing on this field (within Shoebox) would yield a vernacular thesaurus.
\lng English
\mkrOverThis sd
\CharStyle
\-mkr

\+mkr va
\nam Variant form(s)
\desc Where variant forms of the lexical entry or subentry can be noted (e.g. forms from another dialect or minor alternations in the focus dialect). Usually refers to minor or minimal entries found elsewhere in the dictionary.
\lng vernacular
\mkrOverThis lx
\CharStyle
\-mkr

\+mkr va
\nam Variant form(s)
\desc Where variant forms of the lexical entry or subentry can be noted (e.g. forms from another dialect or minor alternations in the focus dialect). Usually refers to minor or minimal entries found elsewhere in the dictionary.
\lng vernacular
\mkrOverThis se
\CharStyle
\-mkr

\+mkr vn
\nam Variant comment (n)
\desc Where national language comments can be given for the variant form.
\lng national
\mkrOverThis va
\CharStyle
\-mkr

\+mkr un
\nam Usage (n)
\desc This field should cover, in the national language, such information as common usage, or restrictions in usage (such as taboos) that is needed so a non-native speaker can use this lexeme properly.
\lng national
\mkrOverThis gn
\CharStyle
\-mkr

\+mkr xe
\nam Example free trans. (E)
\desc This provides the English translation of the example sentence given in the \xv field.
\lng English
\mkrOverThis xv
\CharStyle
\-mkr

\+mkr xn
\nam Example free trans. (n)
\desc This provides the national language translation of the example sentence given in the \xv field.
\lng national
\mkrOverThis xv
\CharStyle
\-mkr

\+mkr xv
\nam Example (v)
\desc Used to give an example or illustritive sentence in the vernacular to legitimate or exemplify each separate sense. Should be short and natural.
\lng vernacular
\mkrOverThis rf
\CharStyle
\-mkr

\+mkr xvnord
\nam Example (v)
\desc Used to give an example or illustritive sentence in the vernacular to legitimate or exemplify each separate sense. Should be short and natural.
\lng vernacular
\mkrOverThis rf
\CharStyle
\-mkr

\+mkr xvUP
\nam Example (v)
\desc Used to give an example or illustritive sentence in the vernacular to legitimate or exemplify each separate sense. Should be short and natural.
\lng vernacular
\mkrOverThis rf
\mkrFollowingThis rf
\CharStyle
\-mkr

\-mkrset
\iInterlinCharWd 10
\+filset 

\-filset
\+drflst 
\-drflst
\+template 
\fld \ps
\fld \ge
\fld \re
\fld \de
\fld \gn
\fld \rn
\fld \dn\n
\fld \rf
\fld \xv
\fld \xe
\fld \xn\n
\fld \ue
\fld \un
\fld \cf
\fld \ce\n
\fld \nt
\fld \dt
\-template
\mkrRecord lx
\mkrSecKey hm
\mkrDateStamp dt
\mkrMultipleMatchShow ge
\+PrintProperties 
\header File: &f, Date: &d
\footer Page &p
\topmargin 1.00 in
\leftmargin 0.25 in
\bottommargin 1.00 in
\rightmargin 0.25 in
\recordsspace 100
\-PrintProperties
\+expset 

\+expMDF Multi-Dictionary Formatter
\ver 4.0
\titleEnglishDiglot Selaru � English Dictionary
\titleEnglishTriglot Selaru � English � Indonesian Dictionary
\titleEnglishFinderlist English � Selaru
\titleNationalDiglot Kamus Selaru � Bahasa Indonesia
\titleNationalTriglot Kamus Selaru � Bahasa Indonesia � Ingris
\titleNationalFinderlist Bahasa Indonesia � Selaru
\cctEnglishLabels mdf_eng.cct
\dotEnglish mdf_e.dot
\cctNationalLabels mdf_inz.cct
\dotNational mdf_n.dot
\typRTF MDF Rich Text Format
\+mkrsubsetExcluded 
\mkr dt
\mkr ec
\mkr es
\mkr is
\mkr re
\mkr rn
\mkr rr
\mkr sd
\mkr so
\mkr st
\mkr th
\mkr we
\mkr wn
\mkr wr
\-mkrsubsetExcluded
\+rtfPageSetup 
\paperSize letter
\topMargin 0.75
\bottomMargin 1.25
\leftMargin 0.75
\rightMargin 0.75
\gutter 0.5
\headerToEdge 0.375
\footerToEdge 0.875
\columns 2
\columnSpacing 0.25
\-rtfPageSetup
\-expMDF

\+expRTF Rich Text Format
\exportedFile D:\WINNT\Profiles\markem\Desktop\showboxExport2.rtf
\+rtfPageSetup 
\paperSize letter
\topMargin 1
\bottomMargin 1
\leftMargin 1.25
\rightMargin 1.25
\gutter 0
\headerToEdge 0.5
\footerToEdge 0.5
\columns 1
\columnSpacing 0.5
\-rtfPageSetup
\-expRTF

\+expSF Standard Format
\-expSF

\expDefault Rich Text Format
\CurrentRecord
\AutoOpen
\MDF
\-expset
\-DatabaseType

