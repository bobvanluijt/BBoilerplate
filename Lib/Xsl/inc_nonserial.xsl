<?xml version="1.0"?>
<!-- @copyright Elsevier UCD -->
<!-- @author Stefan Kuip -->
<!-- @date 2013-09-16 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
	exclude-result-prefixes="bk cals ce ja mml sb tb xlink xocs xoe"
>
	<xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes" />

	<xsl:template match="xocs:nonserial-item">
		<div class="head">
			<div class="publisher">
				<xsl:call-template name="image">
					<xsl:with-param name="src" select="$logo_url" />
					<xsl:with-param name="alt" select="'Publisher logo'" />
					<xsl:with-param name="height" select="80" />
				</xsl:call-template>
			</div>
			<div class="publication">
				<div class="title">
					<a href="{$publication_url}" title="Go to {$meta/xocs:srctitle} on SciVerse ScienceDirect">
						<xsl:apply-templates select="$meta/xocs:srctitle" />
					</a>
				</div>
				<xsl:choose>
					<xsl:when test="$meta/xocs:aip-text">
						<p class="aip">
							<xsl:apply-templates select="$meta/xocs:aip-text" />
						</p>
					</xsl:when>
					<xsl:otherwise>
						<p class="volume-issue">
							<xsl:for-each select="$meta/xocs:vol-iss-suppl-text">
								<a href="{$publication_url}" title="Go to volume and issue page"><xsl:apply-templates/></a>
								<xsl:text>, </xsl:text>
							</xsl:for-each>
							<xsl:for-each select="$meta/xocs:cover-date-text">
								<xsl:apply-templates/>
								<xsl:text>, </xsl:text>
							</xsl:for-each>
							<xsl:for-each select="$meta/xocs:pages">
								<xsl:choose>
									<xsl:when test="1 = position()">Pages </xsl:when>
									<xsl:otherwise>, </xsl:otherwise>
								</xsl:choose>
								<xsl:apply-templates select="xocs:first-page" />
								<xsl:if test="xocs:last-page">
									<xsl:text>–</xsl:text>
									<xsl:apply-templates select="xocs:last-page" />
								</xsl:if>
							</xsl:for-each>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="cover">
				<a href="{$publication_url}" title="Go to {$meta/xocs:srctitle} on SciVerse ScienceDirect">
					<xsl:call-template name="image">
						<xsl:with-param name="alt" select="''" />
						<xsl:with-param name="cover" select="'cover'" />
						<xsl:with-param name="height" select="80" />
						<xsl:with-param name="src" select="concat($image_url,//xocs:hub-eid,'-cov150h.gif')" />
					</xsl:call-template>
				</a>
			</div>
		</div>

		<xsl:apply-templates />
	</xsl:template>

<!-- DOCTYPE -->

	<xsl:template match="bk:bibliography">
		<xsl:apply-templates />
	</xsl:template>

<!-- DOCTYPE -->

	<xsl:template match="bk:book">
		<xsl:apply-templates />
	</xsl:template>

<!-- DOCTYPE -->

	<xsl:template match="bk:chapter">
		<xsl:apply-templates select="ce:title|ce:subtitle|ce:author-group" />

		<ul class="articleInfo">
			<li>
				<xsl:apply-templates select="$doi" />
			</li>
		</ul>

		<xsl:call-template name="guest-access" />

		<xsl:apply-templates select="ce:displayedquote|poem|objectives" />
		<xsl:apply-templates select="ce:keywords|ce:nomenclature|ce:acknowledgment|ce:intro" />
		<xsl:apply-templates select="ce:sections|bk:subchapter" />
		<xsl:apply-templates select="ce:bibliography|ce:further-reading|ce:section|bk:exam|ce:biography" />

		<xsl:apply-templates select="ce:author-group/ce:correspondence" />
		<xsl:apply-templates select="ce:footnote" mode="render"/>
		<xsl:apply-templates select=".//ce:footnote" mode="render"/>

	</xsl:template>

	<xsl:template match="bk:chapter/ce:label">
		<xsl:apply-templates />
		<xsl:text>. </xsl:text>
	</xsl:template>

	<xsl:template match="bk:chapter/ce:title">
		<h1>
			<xsl:apply-templates select="../ce:label" />
			<xsl:apply-templates />
		</h1>
	</xsl:template>

	<xsl:template match="bk:chapter/ce:section">
		<h2>
			<xsl:apply-templates select="ce:label" />
			<xsl:apply-templates select="ce:section-title" />
		</h2>

		<xsl:apply-templates select="node()[not(self::ce:label) and not(self::ce:section-title)]">
			<xsl:with-param name="level" select="2" />
		</xsl:apply-templates>
	</xsl:template>

<!-- DOCTYPE -->
	<xsl:template match="bk:examination">
		<xsl:apply-templates select="ce:title|ce:author-group" />

		<ul class="articleInfo">
			<li>
				<xsl:apply-templates select="$doi" />
			</li>
		</ul>

		<xsl:call-template name="guest-access" />

		<xsl:apply-templates select="ce:intro|bk:exam" />
	</xsl:template>

<!-- DOCTYPE -->
	<xsl:template match="bk:fb-non-chapter">
		<xsl:apply-templates select="ce:title" />

		<ul class="articleInfo">
			<li>
				<xsl:apply-templates select="$doi" />
			</li>
		</ul>

		<xsl:call-template name="guest-access" />

		<xsl:apply-templates select="ce:author-group|ce:nomenclature|ce:para|ce:section|ce:bibliography" />
	</xsl:template>

<!-- DOCTYPE -->
	<xsl:template match="bk:glossary">
		<xsl:apply-templates select="ce:title" />

		<ul class="articleInfo">
			<li>
				<xsl:apply-templates select="$doi" />
			</li>
		</ul>

		<xsl:call-template name="guest-access" />

		<xsl:apply-templates select="ce:glossary" />
	</xsl:template>

<!-- DOCTYPE -->
	<xsl:template match="bk:index">
		<xsl:apply-templates select="ce:index" />
	</xsl:template>

<!-- DOCTYPE -->
	<xsl:template match="bk:introduction">
		<xsl:apply-templates />
	</xsl:template>

<!-- DOCTYPE -->
	<xsl:template match="bk:simple-chapter">
		<xsl:apply-templates select="ce:title|ce:subtitle|ce:author-group|ce:miscellaneous" />

		<ul class="articleInfo">
			<li>
				<xsl:apply-templates select="$doi" />
			</li>
		</ul>

		<!-- <xsl:call-template name="guest-access" /> -->

		<xsl:if test="ce:abstract">
			<xsl:apply-templates select="ce:abstract" />
		</xsl:if>

		<hr />

		<xsl:apply-templates select="ce:displayed-quote|bk:poem|bk:objectives|ce:nomenclature|ce:acknowledgment|ce:intro" />
		<xsl:apply-templates select="ce:sections|bk:subchapter|bk:exam|ce:bibliography|ce:further-reading|ce:section" />

		<xsl:apply-templates select="ce:author-group/ce:correspondence" />
		<xsl:apply-templates select="ce:footnote" mode="render"/>
		<xsl:apply-templates select=".//ce:footnote" mode="render"/>
	</xsl:template>

<!-- DOCTYPE -->

	<xsl:template match="bk:outline">
	</xsl:template>

	<xsl:template name="guest-access">
		<!--
		<xsl:if test="$guest">
			<ul class="guest_access">
				<li>
					<a class="js_nyi button" href="#">View full text</a>
				</li>
				<li class="pdf_purchase">
					<a class="js_nyi icon button" href="#"><span class="icon bigpdf">&#160;</span>
						<span>
							<xsl:text>Purchase </xsl:text>
							<xsl:choose>
								<xsl:when test="1 * 262144 &gt; TODO">$9.95</xsl:when>
								<xsl:when test="2 * 262144 &gt; TODO">$14.95</xsl:when>
								<xsl:when test="3 * 262144 &gt; TODO">$19.95</xsl:when>
								<xsl:when test="4 * 262144 &gt; TODO">$27.50</xsl:when>
								<xsl:when test="5 * 262144 &gt; TODO">$31.95</xsl:when>
								<xsl:when test="6 * 262144 &gt; TODO">$35.50</xsl:when>
								<xsl:otherwise>$31.95</xsl:otherwise>
							</xsl:choose>
						</span>
					</a>
				</li>
			</ul>
		</xsl:if>
		-->
	</xsl:template>

</xsl:stylesheet>
