<?xml version="1.0" standalone="no"?>
<lexicon xmlns="http://chaperon.sourceforge.net/schema/lexicon/1.0">

    <!-- DatabaseType -->
    <lexeme symbol="fortune-start">
        <bol/>
        <concat>
            <cstring content="%"/>
            <cstring content="&#10;"/>
        </concat>
    </lexeme>

    <!-- eols. -->
    <lexeme symbol="lf">
        <cclass minOccurs="1" maxOccurs="1000">
            <cset content="&#10;"/>
        </cclass>
    </lexeme>

    <!-- Any character . -->
    <lexeme symbol="text">
        <cclass exclusive="true"  minOccurs="1" maxOccurs="*">
            <cset content="%"/>
        </cclass>
    </lexeme>
    <lexeme symbol="text">
        <cstring content="%"/>
    </lexeme>
</lexicon>
