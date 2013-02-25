<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:target="target-namespace"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:display="http://www.mpi.nl/lexus/display/1.0"
	xmlns:lexus="http://www.mpi.nl/lexus" xmlns:rr="http://nl.mpi.lexus/resource-resolver"
	exclude-result-prefixes="#all" version="2.0">

	<xsl:namespace-alias stylesheet-prefix="target" result-prefix="xsl"/>
	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="text"/>
	<xsl:output indent="yes"/>

	<xsl:param name="lexicon-id" select="''"/>

	<xsl:template match="lexus:display">
		<target:stylesheet version="2.0">

			<target:strip-space elements="*"/>
			<target:preserve-space elements="text"/>

			<target:output indent="no"/>

			<target:template match="/">
				<display:page>
					<xsl:copy-of select="@*"/>
					<display:style>
						<xsl:value-of select="style"/> &#160; </display:style>
					<display:structure>
						<xsl:apply-templates select="structure"/>
					</display:structure>
				</display:page>
			</target:template>

			<!--
				Display a data element that has a resource/multimedia element, use
				child element <value/>. <resource
				value="409dff22-1629-44b6-a294-687355d52ca4.jpg" archive="local"
				mimetype="image/jpeg" type="image"/>
			-->
			<target:template match="data[resource[@type = 'image']]" priority="1">
				<div style="border: thin solid silver;max-width: 320px;padding: 10px;" block="true">
					<img>
						<target:attribute name="alt">
							<target:value-of
								select="concat(value, ' (the resource is currently unreachable!!!)')"
							/>
						</target:attribute>
						<target:attribute name="src">
							<target:value-of
								select="concat('resource:',resource/@archive,':',resource/@value)"/>
						</target:attribute>
						<target:element name="resource-id-to-url"
							namespace="http://nl.mpi.lexus/resource-resolver">
							<target:copy-of select="resource/@*"/>
							<target:attribute name="lexiconId">
								<target:value-of select="'{$lexicon-id}'"/>
							</target:attribute>
						</target:element>
					</img>
					<br/>
					<text>
						<target:value-of select="value"/>
					</text>
				</div>
			</target:template>

			<!--
				Display a data element, use child element <value/>.
			-->
			<target:template match="data">
				<text>
					<target:value-of select="value"/>
				</text>
			</target:template>

			<!--
                Copy text not explicitly matched.
            -->
			<target:template match="text()" priority="2">
				<target:copy/>
			</target:template>
		</target:stylesheet>
	</xsl:template>
	<xsl:template match="show[@optional = 'true']" priority="1">
		<xsl:choose>
			<xsl:when test="(not(@optional) or @optional eq 'true') and .//data">
				<target:if>
					<xsl:attribute name="test">
						<xsl:for-each select=".//data">
							<xsl:variable name="d" select="."/>
							<xsl:text>.//data[@schema-ref='</xsl:text>
							<xsl:value-of select="$d/@id"/>
							<xsl:text>']</xsl:text>
							<xsl:if test="position() ne last()">
								<xsl:text> | </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:attribute>
					<div>
						<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
						<xsl:apply-templates/>
					</div>
				</target:if>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="show">
		<div>
			<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="text">
		<xsl:copy>
			<xsl:copy-of select="@dsl_class"/>
			<xsl:value-of select="@value"/>
		</xsl:copy>
	</xsl:template>

	<!--
		A <data/> element in the DSL matches data elements in the LE based on
		their @schema-ref attribute.
	-->
	<xsl:template match="data">
		<div>
			<xsl:copy-of
				select="@*[local-name(.) != 'isBranch' and local-name(.) != 'id' and local-name(.) != 'type' and local-name(.) != 'name']"/>
			<target:apply-templates select="descendant-or-self::node()[@schema-ref = '{./@id}']"/>
		</div>
	</xsl:template>
	<xsl:template match="lbreak">
		<br/>
	</xsl:template>
	<xsl:template match="hline">
		<hr>
			<xsl:apply-templates select="@size"/>
		</hr>
	</xsl:template>
	<!-- Process multipliers -->
	<xsl:template
		match="multiplier[@type = 'dsl_multiplier' and not(count(./data) = 1 and count(./*/*) = 0)]">
		<xsl:choose>
			<xsl:when test=".//data">
				<target:variable name="containers-{generate-id(.)}">
					<xsl:attribute name="select">
						<xsl:for-each select=".//data">
							<xsl:variable name="d" select="."/>
							<xsl:text>.//data[@schema-ref='</xsl:text>
							<xsl:value-of select="$d/@id"/>
							<xsl:text>']/parent::node()</xsl:text>
							<xsl:if test="position() ne last()">
								<xsl:text> | </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:attribute>
				</target:variable>
				<target:variable name="first-{generate-id(.)}"
					select="$containers-{generate-id(.)}[1]"/>
				<target:variable name="siblings-{generate-id(.)}"
					select="$containers-{generate-id(.)}[1]/following-sibling::*"/>
				<target:if test="$first-{generate-id(.)}">
					<div>
						<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
						<target:variable name="displayContainers-{generate-id(.)}"
							select="$first-{generate-id(.)} | ($siblings-{generate-id(.)})/self::node()[@id = $containers-{generate-id(.)}/@id]"/>
						<target:variable name="doubles-{generate-id(.)}">
							<target:for-each select="$displayContainers-{generate-id(.)}">
								<target:variable name="displayContainer" select="."/>
								<target:if
									test="count($displayContainers-{generate-id(.)}[@schema-ref = $displayContainer/@schema-ref]) &gt; 1">
									<target:value-of select="'x'"/>
								</target:if>
							</target:for-each>
						</target:variable>
						<target:if test="$doubles-{generate-id(.)} = ''">
							<xsl:apply-templates/>
						</target:if>
						<target:if test="not($doubles-{generate-id(.)} = '')">
							<target:for-each select="$displayContainers-{generate-id(.)}">
								<xsl:apply-templates/>
							</target:for-each>
						</target:if>
					</div>
				</target:if>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Separately handle multiplier elements with a single data child. So that text child of this show element are repeated in
	case we have multiple instances of the child data category at the lexical entry level. -->
	<xsl:template
		match="multiplier[@type = 'dsl_multiplier' and (count(./data) = 1 and count(./*/*) = 0)]">
		<target:if test=".//data[@schema-ref = '{.//data/@id}']">
			<div>
				<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
				<target:for-each select=".//data[@schema-ref = '{.//data/@id}']">
					<xsl:apply-templates/>
				</target:for-each>
			</div>
		</target:if>
	</xsl:template>
	<xsl:template match="container[@id]">
		<target:template match="container[@schema-ref eq '{@id}']">
			<xsl:apply-templates mode="apply"/>
		</target:template>
	</xsl:template>




	<!--
		<table type="dsl_table" name="Table" isBranch="true"> <thead
		name="Heading" type="dsl_table_heading" isBranch="true"> <row
		type="dsl_table_row" isBranch="true" name="Table row"> <col
		type="dsl_table_column" name="Table column" isBranch="true"> <text
		name="text" value="Subentry" isBranch="false" type="dsl_text"/> </col>
		<col type="dsl_table_column" name="Table column" isBranch="true">
		<text name="text" value="Homonym number" isBranch="false"
		type="dsl_text"/> </col> </row> </thead> <tbody name="Table body"
		type="dsl_table_body" isBranch="true"> <list
		id="uuid:2c9090a21a6d44e9011a714ccb140253" name="SubentryGroup"
		type="container" isBranch="true"> <row type="dsl_table_row"
		name="Table row" isBranch="true"> <col type="dsl_table_column"
		name="Table column" isBranch="true"> <data
		id="uuid:2c9090a21a6d44e9011a714ccb1c027f" name="Subentry" type="data
		category" isBranch="false"/> </col> <col type="dsl_table_column"
		name="Table column" isBranch="true"> <data
		id="uuid:2c9090a21a6d44e9011a714ccb1c027b" name="Homonym number"
		type="data category" isBranch="false"/> </col> </row> </list> </tbody>
		</table>
	-->
	<xsl:template match="table[@type = 'dsl_table']">
		<xsl:copy>
			<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="thead[@type eq 'dsl_table_heading'] | tbody[@type eq 'dsl_table_body']">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="row[@type eq 'dsl_table_row']">
		<xsl:choose>
			<xsl:when test="(not(@optional) or @optional eq 'true') and .//data">
				<target:variable name="containers-{generate-id(.)}">
					<xsl:attribute name="select">
						<xsl:for-each select=".//data">
							<xsl:variable name="d" select="."/>
							<xsl:text>.//data[@schema-ref='</xsl:text>
							<xsl:value-of select="$d/@id"/>
							<xsl:text>']/parent::node()</xsl:text>
							<xsl:if test="position() ne last()">
								<xsl:text> | </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:attribute>
				</target:variable>
				<target:variable name="first-{generate-id(.)}"
					select="$containers-{generate-id(.)}[1]"/>
				<target:variable name="siblings-{generate-id(.)}"
					select="$containers-{generate-id(.)}[1]/following-sibling::*"/>
				<target:choose>
					<target:when test="$first-{generate-id(.)}">
						<tr>
							<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
							<target:variable name="displayContainers-{generate-id(.)}"
								select="$first-{generate-id(.)} | ($siblings-{generate-id(.)})/self::node()[@id = $containers-{generate-id(.)}/@id]"/>
							<target:variable name="doubles-{generate-id(.)}">
								<target:for-each select="$displayContainers-{generate-id(.)}">
									<target:variable name="displayContainer" select="."/>
									<target:if
										test="count($displayContainers-{generate-id(.)}[@schema-ref = $displayContainer/@schema-ref]) &gt; 1">
										<target:value-of select="'x'"/>
									</target:if>
								</target:for-each>
							</target:variable>
							<target:if test="$doubles-{generate-id(.)} = ''">
								<xsl:apply-templates/>
							</target:if>
							<target:if test="not($doubles-{generate-id(.)} = '')">
								<td>
								<table>
									<tbody>
									<target:for-each select="$displayContainers-{generate-id(.)}">
										<tr>
											<xsl:apply-templates />
										</tr>
									</target:for-each>
									</tbody>
								</table>
								</td>
							</target:if>
						</tr>
					</target:when>
					<target:otherwise>
						<tr>
							<xsl:apply-templates/>
						</tr>
					</target:otherwise>
				</target:choose>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
					<xsl:apply-templates/>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="thead//col[@type eq 'dsl_table_column']" priority="1">
		<th>
			<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
			<xsl:apply-templates/>
		</th>
	</xsl:template>
	<xsl:template match="col[@type eq 'dsl_table_column']">
		<td>
			<xsl:copy-of select="@*[local-name(.) != 'isBranch']"/>
			<xsl:apply-templates/>
		</td>
	</xsl:template>


	<xsl:template match="text()">
		<text>
			<xsl:copy/>
		</text>
	</xsl:template>
	<xsl:template match="@*" mode="apply #default">
		<xsl:copy/>
	</xsl:template>
</xsl:stylesheet>
