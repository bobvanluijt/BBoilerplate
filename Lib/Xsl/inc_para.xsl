<?xml version="1.0"?>
<!-- @copyright Elsevier UCD -->
<!-- @author Stefan Kuip -->
<!-- @date 2013-09-16 -->

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:bk="http://www.elsevier.com/xml/bk/dtd"
	xmlns:cals="http://www.elsevier.com/xml/common/cals/dtd"
	xmlns:ce="http://www.elsevier.com/xml/common/dtd"
	xmlns:ja="http://www.elsevier.com/xml/ja/dtd"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"
	xmlns:sb="http://www.elsevier.com/xml/common/struct-bib/dtd"
	xmlns:tb="http://www.elsevier.com/xml/common/table/dtd"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xocs="http://www.elsevier.com/xml/xocs/dtd"
	xmlns:xoe="http://www.elsevier.com/xml/xoe/dtd"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="bk cals ce ja mml sb tb xlink xocs xoe"
>

	<!-- http://www.techques.com/question/1-5147803/XSLT:-make-a-child-node-a-sibling-of-the-context-node -->

	<!-- note-para -->

	<xsl:key
		name="keyNoteParagraph" match="ce:note-para/node()[not(self::ce:def-list|self::ce:display|self::ce:displayed-quote|self::ce:enunciation|self::ce:list)]"
		use="generate-id((..|preceding-sibling::*[self::ce:def-list|self::ce:display|self::ce:displayed-quote|self::ce:enunciation|self::ce:list][1])[last()])" />

    <xsl:template match="ce:note-para">
		<xsl:param name="prepend" />
        <xsl:apply-templates select=".|ce:def-list|ce:display|ce:displayed-quote|ce:enunciation|ce:list" mode="group">
		</xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ce:note-para" mode="group" name="makeNotePara">
		<xsl:param name="prepend" />
        <xsl:variable name="vGroup" select="key('keyNoteParagraph',generate-id())" />
        <xsl:if test="$vGroup">
            <p class="para">
				<xsl:if test="$vGroup/@id">
					<xsl:attribute name="id">
						<xsl:value-of select="$vGroup/@id"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="'' != $prepend"><xsl:copy-of select="$prepend" /></xsl:if>
                <xsl:apply-templates select="$vGroup" />
            </p>
        </xsl:if>
    </xsl:template>

	<!-- simple-para -->

	<xsl:key
		name="keySimpleParagraph" match="ce:simple-para/node()[not(self::ce:def-list|self::ce:display|self::ce:displayed-quote|self::ce:enunciation|self::ce:list)]"
		use="generate-id((..|preceding-sibling::*[self::ce:def-list|self::ce:display|self::ce:displayed-quote|self::ce:enunciation|self::ce:list][1])[last()])" />

    <xsl:template match="ce:simple-para">
		<xsl:param name="prepend" />
        <xsl:apply-templates select=".|ce:def-list|ce:display|ce:displayed-quote|ce:enunciation|ce:list" mode="group">
			<xsl:with-param name="prepend" select="$prepend" />
		</xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ce:simple-para" mode="group" name="makeSimplePara">
		<xsl:param name="prepend" />
        <xsl:variable name="vGroup" select="key('keySimpleParagraph',generate-id())" />
        <xsl:if test="$vGroup">
			<p class="para">
				<xsl:if test="$vGroup/@id">
					<xsl:attribute name="id">
						<xsl:value-of select="$vGroup/@id"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="'' != $prepend"><xsl:copy-of select="$prepend" /></xsl:if>
                <xsl:apply-templates select="$vGroup" />
            </p>
        </xsl:if>
    </xsl:template>

	<!-- para -->

	<xsl:key
		name="keyNormalParagraph" match="ce:para/node()[not(self::ce:def-list|self::ce:display|self::ce:displayed-quote|self::ce:enunciation|self::ce:list)]"
		use="generate-id((..|preceding-sibling::*[self::ce:def-list|self::ce:display|self::ce:displayed-quote|self::ce:enunciation|self::ce:list][1])[last()])" />

    <xsl:template match="ce:para">
		<xsl:param name="prepend" />
        <xsl:apply-templates select=".|ce:def-list|ce:display|ce:displayed-quote|ce:enunciation|ce:list" mode="group">
			<xsl:with-param name="prepend" select="$prepend" />
		</xsl:apply-templates>
		<xsl:apply-templates select="ce:float-anchor" mode="render" />
    </xsl:template>

    <xsl:template match="ce:para" mode="group" name="makeNormalPara">
		<xsl:param name="prepend" />
        <xsl:variable name="vGroup" select="key('keyNormalParagraph',generate-id())" />
        <xsl:if test="$vGroup">
			<p class="para">
				<xsl:if test="@id">
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="'' != $prepend"><xsl:copy-of select="$prepend" /></xsl:if>
                <xsl:apply-templates select="$vGroup" />
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="group">
		<xsl:param name="prepend" />
        <xsl:apply-templates select="." />
        <xsl:call-template name="makeNotePara">
			<xsl:with-param name="prepend" select="$prepend" />
		</xsl:call-template>
        <xsl:call-template name="makeSimplePara">
			<xsl:with-param name="prepend" select="$prepend" />
		</xsl:call-template>
		<xsl:call-template name="makeNormalPara" />
    </xsl:template>

</xsl:stylesheet>
