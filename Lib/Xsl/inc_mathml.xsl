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

	<xsl:template match="mml:math//ce:bold">
		<mtext mathvariant="bold"><xsl:apply-templates /></mtext>
	</xsl:template>
	<xsl:template match="mml:math//ce:glyph">
		<mglyph src="{$base_url}images/glyphs/{@name}.gif" />
	</xsl:template>
	<xsl:template match="mml:math//ce:italic">
		<mtext mathvariant="italic"><xsl:apply-templates /></mtext>
	</xsl:template>
	<xsl:template match="mml:math//ce:cross-ref">
		<xsl:text> </xsl:text>
		<xsl:value-of select="." />
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mml:mext">
		<mext><xsl:apply-templates /></mext>
	</xsl:template>
	<xsl:template match="mml:mfenced">
		<mfenced>
			<xsl:if test="@close"><xsl:attribute name="close"><xsl:value-of select="@close"/></xsl:attribute></xsl:if>
			<xsl:if test="@open"><xsl:attribute name="open"><xsl:value-of select="@open"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</mfenced>
	</xsl:template>
	<xsl:template match="mml:mfrac">
		<mfrac><xsl:apply-templates /></mfrac>
	</xsl:template>
	<xsl:template match="mml:mi">
		<mi>
			<xsl:if test="@mathvariant"><xsl:attribute name="mathvariant"><xsl:value-of select="@mathvariant"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</mi>
	</xsl:template>
	<xsl:template match="mml:mn">
		<mn>
			<xsl:if test="@mathvariant"><xsl:attribute name="mathvariant"><xsl:value-of select="@mathvariant"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</mn>
	</xsl:template>
	<xsl:template match="mml:mo">
		<mo>
			<xsl:if test="@stretchy"><xsl:attribute name="stretchy"><xsl:value-of select="@stretchy"/></xsl:attribute></xsl:if>
			<xsl:if test="@mathvariant"><xsl:attribute name="mathvariant"><xsl:value-of select="@mathvariant"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</mo>
	</xsl:template>
	<xsl:template match="mml:mrow">
		<mrow><xsl:apply-templates /></mrow>
	</xsl:template>
	<xsl:template match="mml:mspace">
		<mspace>
			<xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
			<xsl:if test="@width"><xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</mspace>
	</xsl:template>
	<xsl:template match="mml:mstyle">
		<mstyle>
			<xsl:if test="@mathvariant"><xsl:attribute name="mathvariant"><xsl:value-of select="@mathvariant"/></xsl:attribute></xsl:if>
			<xsl:if test="@displaystyle"><xsl:attribute name="displaystyle"><xsl:value-of select="@displaystyle"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</mstyle>
	</xsl:template>
	<xsl:template match="mml:msub">
		<msub><xsl:apply-templates /></msub>
	</xsl:template>
	<xsl:template match="mml:msubsup">
		<msubsup><xsl:apply-templates /></msubsup>
	</xsl:template>
	<xsl:template match="mml:msup">
		<msup><xsl:apply-templates /></msup>
	</xsl:template>
	<xsl:template match="mml:mtable">
		<mtable>
			<xsl:if test="@columnspacing"><xsl:attribute name="columnspacing"><xsl:value-of select="@columnspacing"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</mtable>
	</xsl:template>
	<xsl:template match="mml:mtd">
		<mtd>
			<xsl:if test="@columnalign"><xsl:attribute name="columnalign"><xsl:value-of select="@columnalign"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</mtd>
	</xsl:template>
	<xsl:template match="mml:mtext">
		<mtext><xsl:apply-templates /></mtext>
	</xsl:template>
	<xsl:template match="mml:mtr">
		<mtr><xsl:apply-templates /></mtr>
	</xsl:template>
	<xsl:template match="mml:munder">
		<munder><xsl:apply-templates /></munder>
	</xsl:template>
	<xsl:template match="mml:munderover">
		<munderover>
			<xsl:if test="@accent"><xsl:attribute name="accent"><xsl:value-of select="@accent"/></xsl:attribute></xsl:if>
			<xsl:if test="@accentunder"><xsl:attribute name="accentunder"><xsl:value-of select="@accentunder"/></xsl:attribute></xsl:if>
			<xsl:apply-templates />
		</munderover>
	</xsl:template>

</xsl:stylesheet>
