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

	<!-- Key database for finding and generating id's -->
	<xsl:key name="type-file-id" use="concat(xocs:attachment-type,xocs:filename)"
		match="//xocs:attachment" />

	<xsl:key name="basename-id" use="xocs:file-basename" match="//xocs:attachment" />
	<xsl:key name="filename-id" use="xocs:filename" match="//xocs:attachment" />

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template name="label_and_or_section-title">
		<xsl:apply-templates select="ce:label"/>
		<xsl:if test="ce:label and ce:section-title">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="ce:section-title" />
	</xsl:template>

	<xsl:template name="seperateBySpace">
		<xsl:for-each select="*">
			<xsl:if test="1 != position()">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="seperateByComma">
		<xsl:for-each select="*">
			<xsl:if test="1 != position()">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="renderBasename">
		<xsl:param name="type" select="'IMAGE-DOWNSAMPLED'" />
		<xsl:param name="id" />
		<xsl:param name="class" select="'figure'" />
		<xsl:param name="altText" />

		<xsl:call-template name="image">
			<xsl:with-param name="altText" select="$altText" />
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="sources" select="key('basename-id', $id)" />
			<xsl:with-param name="type" select="$type" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="renderFilename">
		<xsl:param name="altText" />
		<xsl:param name="class" select="'math'" />
		<xsl:param name="id" />
		<xsl:param name="type" select="'IMAGE-DOWNSAMPLED'" />

		<xsl:call-template name="image">
			<xsl:with-param name="altText" select="$altText" />
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="sources" select="key('filename-id', $id)" />
			<xsl:with-param name="type" select="$type" />
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="renderFormula">
		<xsl:param name="altText" select="'Math figure'" />
		<xsl:param name="class" select="'mathformula'" />
		<xsl:param name="id" />
		<xsl:param name="type" select="'ALTIMG'" />

		<xsl:call-template name="image">
			<xsl:with-param name="altText" select="$altText" />
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="sources" select="key('filename-id', $id)" />
			<xsl:with-param name="type" select="$type" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="image">
		<xsl:param name="altText" />
		<xsl:param name="class" />
		<xsl:param name="sources" select="''" />
		<xsl:param name="src" select="''" />
		<xsl:param name="type" />

		<xsl:param name="width" select="''" />
		<xsl:param name="height" select="''" />

		<img alt="{$altText}">
			<xsl:if test="'' != $class" ><xsl:attribute name="class" ><xsl:value-of select="$class"  /></xsl:attribute></xsl:if>

			<xsl:choose>
				<xsl:when test="'' != $src">
					<xsl:attribute name="src" ><xsl:value-of select="$src" /></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$sources">
						<xsl:choose>
							<xsl:when test="$type = xocs:attachment-type">
								<xsl:attribute name="src" ><xsl:value-of select="concat($image_url,xocs:attachment-eid)" /></xsl:attribute>
								<xsl:attribute name="width" ><xsl:value-of select="xocs:pixel-width" /></xsl:attribute>
								<xsl:attribute name="height" ><xsl:value-of select="xocs:pixel-height" /></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="data-{translate(xocs:attachment-type, $uppercase, $smallcase)}-src" ><xsl:value-of select="concat($image_url,xocs:attachment-eid)" /></xsl:attribute>
								<xsl:attribute name="data-{translate(xocs:attachment-type, $uppercase, $smallcase)}-width" ><xsl:value-of select="xocs:pixel-width" /></xsl:attribute>
								<xsl:attribute name="data-{translate(xocs:attachment-type, $uppercase, $smallcase)}-height" ><xsl:value-of select="xocs:pixel-height" /></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</img>

	</xsl:template>

</xsl:stylesheet>
