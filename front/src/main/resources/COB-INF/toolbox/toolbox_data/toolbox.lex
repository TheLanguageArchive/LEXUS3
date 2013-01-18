<?xml version="1.0" standalone="no"?>
<lexicon xmlns="http://chaperon.sourceforge.net/schema/lexicon/1.0">

    <!-- Attribute: f.i. \nam -->
    <lexeme symbol="attribute">
        <concat>
            <bol/>
            <cstring content="\"/>
            <cclass minOccurs="1" maxOccurs="1">
                <cset content="_"/>
                <cinterval min="A" max="Z"/>
                <cinterval min="a" max="z"/>
            </cclass>
            <cclass minOccurs="0" maxOccurs="40">
                <cset content="_"/>
                <cset content="-"/>
                <cinterval min="A" max="Z"/>
                <cinterval min="a" max="z"/>
                <cinterval min="0" max="9"/>
            </cclass>
        </concat>
    </lexeme>


    <!-- Match eol. -->
    <lexeme symbol="lf">
        <cclass>
            <cset content="&#10;"/>
        </cclass>
    </lexeme>
    <lexeme symbol="lf">
        <concat>
            <cclass minOccurs="1" maxOccurs="1">
                <cset content="&#13;"/>
            </cclass>
            <cclass minOccurs="1" maxOccurs="1">
                <cset content="&#10;"/>
            </cclass>
        </concat>
    </lexeme>

    <!-- Any character . -->
    <lexeme symbol="text">
        <concat>
            <cclass exclusive="true" minOccurs="1" maxOccurs="1">
                <cset content="&#13;"/>
                <cset content="&#10;"/>
                <cset content="\"/>
            </cclass>
            <cclass exclusive="true" minOccurs="0" maxOccurs="*">
                <cset content="&#13;"/>
                <cset content="&#10;"/>
            </cclass>
            <eol/>
        </concat>
        <!--        <cuniversal/>-->
    </lexeme>

</lexicon>
