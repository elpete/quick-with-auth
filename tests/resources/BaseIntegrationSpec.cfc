component extends="coldbox.system.testing.BaseTestCase" {

    property name="migrationService" inject="MigrationService@cfmigrations";

    this.loadColdBox = true;
    this.unloadColdBox = false;

    /**
     * Run Before all tests
     */
    function beforeAll() {
        super.beforeAll();
        // Wire up this object
        application.wirebox.autowire( this );

        // Check if migrations ran before all tests
        if ( ! request.keyExists( "migrationsRan" ) ) {
            migrationService.setMigrationsDirectory( "/root/resources/database/migrations" );
	        migrationService.setDefaultGrammar( "MySQLGrammar" );
            migrationService.setDatasource( "testing" );
            migrationService.runAllMigrations( "down" );
            migrationService.runAllMigrations( "up" );
            request.migrationsRan = true;
        }
    }

    function getInstance() {
        return application.wirebox.getInstance( argumentCollection = arguments );
    }

    /**
     * This function is tagged as an around each handler.  All the integration tests we build
     * will be automatically rolledbacked
     *
     * @aroundEach
     */
    function wrapInTransaction( spec ) {
        transaction action="begin" {
            try {
                arguments.spec.body();
            } catch ( any e ) {
                rethrow;
            } finally {
                transaction action="rollback";
            }
        }
    }

}
