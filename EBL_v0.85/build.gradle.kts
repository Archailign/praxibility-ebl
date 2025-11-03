plugins { java; antlr }
group = "org.example"; version = "0.85"
repositories { mavenCentral() }
val antlrVer = "4.13.1"; val jacksonVer = "2.17.1"
dependencies { antlr("org.antlr:antlr4:$antlrVer"); implementation("org.antlr:antlr4-runtime:$antlrVer"); implementation("com.fasterxml.jackson.core:jackson-databind:$jacksonVer"); testImplementation("org.junit.jupiter:junit-jupiter:5.10.2") }
tasks.generateGrammarSource { arguments = arguments + listOf("-visitor","-listener","-package","org.example.ebl"); outputDirectory = file("$projectDir/generated-src/java") }
sourceSets["main"].java { srcDir("src/main/java"); srcDir("generated-src/java") }
tasks.test { useJUnitPlatform() }
java { toolchain { languageVersion.set(JavaLanguageVersion.of(17)) } }
