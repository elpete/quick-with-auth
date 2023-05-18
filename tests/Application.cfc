/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component{

	// APPLICATION CFC PROPERTIES
	this.name 				= "ColdBoxTestingSuite" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan( 0, 0, 15, 0 );
	this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );
	this.setClientCookies 	= true;

	// Create testing mapping
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	// Map back to its root
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
    this.mappings[ "/root" ]   = rootPath;
    this.mappings[ "/coldbox" ]   = rootPath & "coldbox";

    createObject( "java", "java.lang.System" ).setProperty( "ENVIRONMENT", "testing" );
	variables.util = new coldbox.system.core.util.Util();
    this.datasource = variables.util.getSystemSetting( "TEST_DB_DATABASE" );

	public void function onRequestEnd() {
		structDelete( application, "cbController" );
		structDelete( application, "wirebox" );
	}
}
