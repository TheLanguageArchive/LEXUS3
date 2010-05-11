<?xml version="1.0" standalone="no"?>
<lexicon xmlns="http://chaperon.sourceforge.net/schema/lexicon/1.0">

  <!-- Attribute: f.i. \nam -->
  <lexeme symbol="attribute">
    <concat>
      <cstring content="\"/>
      <cclass minOccurs="1" maxOccurs="40">
        <cset content="_"/>
        <cinterval min="A" max="Z"/>
        <cinterval min="a" max="z"/>
      </cclass>
    </concat>
  </lexeme>
  
  
  <!-- Match eol. -->
  <lexeme symbol="lf">
    <cclass>
      <cset content="&#10;"/>
    </cclass>
  </lexeme>
  
  <!-- Any character . -->
  <lexeme symbol="text">
    <cuniversal/>
  </lexeme>

</lexicon>
