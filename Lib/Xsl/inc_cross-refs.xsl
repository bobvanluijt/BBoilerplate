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
	<xsl:key name="cross-ref-id" match="*[@id]" use="@id"/>

<!-- CE:FLOAT-ANCHOR -->

	<!-- float-anchor is only rendered when specially called. -->
    <xsl:template match="ce:float-anchor" mode="render">
		<xsl:apply-templates select="key('cross-ref-id', @refid)"/>
    </xsl:template>

<!-- CE:CROSS-REF(S) -->

    <xsl:template match="ce:cross-ref">
		<xsl:call-template name="process-id">
			<xsl:with-param name="crossRef" select="."/>
			<xsl:with-param name="refid" select="@refid"/>
		</xsl:call-template>
    </xsl:template>

    <xsl:template match="ce:cross-refs">
		<!-- Don't try to render more than X references, since the solution is
			 a recursive and will run out of memory about 400 id's. -->
		<xsl:choose>
			<!-- Count the number of refid's by counting the replaced spaces.
				 So 99 spaces means 100 refid's -->
			<xsl:when test="99 > string-length(@refid) - string-length(translate(@refid,' ',''))">
				<xsl:call-template name="process-ids">
					<xsl:with-param name="crossRef" select="."/>
					<xsl:with-param name="refids" select="@refid"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- Create only one link pointing to the first refid -->
				<xsl:call-template name="process-id">
					<xsl:with-param name="crossRef" select="."/>
					<xsl:with-param name="overrideContent">
						<xsl:apply-templates />
					</xsl:with-param>
					<xsl:with-param name="refid" select="substring-before(@refid, ' ')"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>

	<!-- Handle every id seperate -->
	<xsl:template name="process-ids">
		<xsl:param name="crossRef"/>
		<xsl:param name="refids"/>

		<xsl:variable name="newlist" select="concat(normalize-space($refids), ' ')" />
		<xsl:variable name="first" select="substring-before($newlist, ' ')" />
		<xsl:variable name="remaining" select="normalize-space(substring-after($newlist, ' '))" />

		<xsl:call-template name="process-id">
			<xsl:with-param name="crossRef" select="$crossRef"/>
			<xsl:with-param name="refid" select="$first"/>
		</xsl:call-template>

		<xsl:if test="$remaining">
			<xsl:variable name="separator">
				<xsl:choose>
					<xsl:when test="contains($remaining, ' ')">
						<xsl:text>, </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> and </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$crossRef//ce:sup">
					<sup><xsl:value-of select="$separator"/></sup>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$separator"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:call-template name="process-ids">
				<xsl:with-param name="crossRef" select="$crossRef"/>
				<xsl:with-param name="refids" select="$remaining"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

	<!-- Convert id to link -->
	<xsl:template name="process-id">
		<xsl:param name="crossRef"/>
		<xsl:param name="refid"/>
		<xsl:param name="overrideContent"/>

		<xsl:variable name="nodeItem" select="key('cross-ref-id', $refid)" />
		<xsl:variable name="nodeName" select="name($nodeItem)" />

		<xsl:variable name="content">
			<!-- When id comes from a single cross use the original label,
				otherwise create one from the label it points to. -->
			<xsl:choose>
				<xsl:when test="'' != $overrideContent">
					<xsl:value-of select="$overrideContent" />
				</xsl:when>
				<xsl:when test="'ce:cross-ref' = name($crossRef)">
					<xsl:apply-templates select="$crossRef/*" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$crossRef//ce:sup">
							<sup>
								<xsl:value-of select="$nodeItem/../ce:label" />
								<xsl:value-of select="$nodeItem/ce:label" />
							</sup>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$nodeItem/../ce:label" />
							<xsl:value-of select="$nodeItem/ce:label" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="aClass">
			<xsl:choose>
				<xsl:when test="$nodeName='ce:anchor'">js_article</xsl:when>
				<xsl:when test="$nodeName='ce:section'">js_article</xsl:when>
				<xsl:when test="$nodeName='ce:para'">js_article</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="aTitlePart">
			<xsl:choose>
				<xsl:when test="$nodeName='ce:affiliation'"		>Affiliation: </xsl:when>
				<xsl:when test="$nodeName='ce:author'"			>Author: </xsl:when>
				<xsl:when test="$nodeName='ce:bib-reference'"	>Reference: </xsl:when>
				<xsl:when test="$nodeName='ce:biography'"		>Biography: </xsl:when>
				<xsl:when test="$nodeName='ce:collaboration'"	>Collaboration: </xsl:when>
				<xsl:when test="$nodeName='ce:correspondence'"	>Corresponding author contact information</xsl:when>
				<xsl:when test="$nodeName='ce:e-component'"		>Ecomponent: </xsl:when>
				<xsl:when test="$nodeName='ce:enunciation'"		>Enunciation: </xsl:when>
				<xsl:when test="$nodeName='ce:figure'"			>Figure: </xsl:when>
				<xsl:when test="$nodeName='ce:footnote'"		>Footnote: </xsl:when>
				<xsl:when test="$nodeName='ce:formula'"			>Formula: </xsl:when>
				<xsl:when test="$nodeName='ce:grant-sponsor'"	>Grantsponsor: </xsl:when>
				<xsl:when test="$nodeName='ce:section'"			>Section: </xsl:when>
				<xsl:when test="$nodeName='ce:table'"			>Table: </xsl:when>
				<xsl:when test="$nodeName='ce:table-footnote'"	>Tablefootnote: </xsl:when>
				<xsl:when test="$nodeName='ce:textbox'"			>Textbox: </xsl:when>
				<xsl:otherwise									>Todo: </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="aTitle">
			<xsl:value-of select="$aTitlePart" />
			<xsl:choose>
				<xsl:when test="$nodeName='ce:correspondence'"></xsl:when>
				<xsl:otherwise><xsl:value-of select="$crossRef" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<a href="#{$refid}" title="{$aTitle}">
			<xsl:if test="'' != $aClass">
				<xsl:attribute name="class">
					<xsl:value-of select="$aClass" />
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="'' != $content"><xsl:copy-of select="$content"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>


	<!-- Convert internal href to link -->
	<xsl:template match="ce:intra-ref">
		<xsl:variable name="hrefScheme" select="substring-before(@xlink:href, ':')" />

		<xsl:variable name="aHref">
			<xsl:choose>
				<xsl:when test="'pii' = $hrefScheme">
					<xsl:value-of select="$base_url" />
					<xsl:text>/intraref/</xsl:text>
					<xsl:value-of select="translate(@xlink:href,'#/()-', '/')" />
				</xsl:when>
				<xsl:when test="'doi' = $hrefScheme">
					<xsl:text>http://dx.doi.org/</xsl:text>
					<xsl:value-of select="$hrefDocument"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<a href="{$aHref}"><xsl:apply-templates /></a>
	</xsl:template>

</xsl:stylesheet>
