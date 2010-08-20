<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" xmlns:util="java:java.util.UUID" version="2.0">

    <xsl:param name="lexiconId" select="''"/>

    <!--
        
        Input is:
        <data>
            <view>
                <name>The name of the view</view>
                <description>Describes the view</description>
            </view>
            <user>...</user>
        </data>
        
      and it should be transformed to something like:
      <data>
        <lexus:create-view lexicon="...">
          <view>
              <name>The name of the view</view>
              <description>Describes the view</description>
          </view>
          </lexus:create-view>
          <user>...</user>
      </data>
      
    -->

    <xsl:include href="../../util/identity.xslt"/>

    <xsl:template match="view">
        <xsl:variable name="id"
            select="if (@id) then @id else concat('uuid:',util:toString(util:randomUUID()))"/>
        <lexus:save-view lexicon="{$lexiconId}">
            <view>
                <xsl:attribute name="id" select="$id"/>
                <xsl:copy-of select="@*|node()"/>
            </view>
        </lexus:save-view>
        <view>
            <xsl:attribute name="id" select="$id"/>
            <xsl:copy-of select="@*|node()"/>
        </view>
    </xsl:template>

</xsl:stylesheet>
