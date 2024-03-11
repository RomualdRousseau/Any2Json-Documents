# Tutorial 4 - Data extraction with defects

[View source on GitHub](https://github.com/RomualdRousseau/Any2Json-Examples).

This tutoral is a continuation of the [Tutorial 43](tutorial_4.md).

This tutorial will demonstrate how to use [Any2Json](https://github.com/RomualdRousseau/Any2Json) to extract data from
one Excel spreadsheet with pivot. To demonstrate the usage of this framework, we will load a document
with a somewhat complex layout, as seen here:

![document with multiple tables](images/tutorial4_data.png)

## Setup Any2Json

### Import the packages and setup the main class:

```java
package com.github.romualdrousseau.any2json.examples;

import java.util.EnumSet;
import java.util.List;

import com.github.romualdrousseau.any2json.Document;
import com.github.romualdrousseau.any2json.DocumentFactory;
import com.github.romualdrousseau.any2json.parser.LayexTableParser;

public class Tutorial5 implements Runnable {

    public Tutorial5() {
    }

    @Override
    public void run() {
        // Code will come here
    }

    public static void main(final String[] args) {
        new Tutorial5().run();
    }
}
```

### pom.xml

Any2Json has a very modular design where each functionality can be loaded separatly. We add the "any2json-net-classifier"
module to enable the tagging capabilities. This module use [TensorFlow](https://www.tensorflow.org/) for Java. The
following depedencies are required to run the code of this tutorial:

```xml
<!-- ShuJu Framework -->
<dependency>
    <groupId>com.github.romualdrousseau</groupId>
    <artifactId>shuju</artifactId>
    <version>${shuju.version}</version>
</dependency>
<dependency>
    <groupId>com.github.romualdrousseau</groupId>
    <artifactId>shuju-jackson</artifactId>
    <version>${shuju.version}</version>
</dependency>
<!-- Any2Json Framework -->
<dependency>
    <groupId>com.github.romualdrousseau</groupId>
    <artifactId>any2json</artifactId>
    <version>${any2json.version}</version>
</dependency>
<dependency>
    <groupId>com.github.romualdrousseau</groupId>
    <artifactId>any2json-layex-parser</artifactId>
    <version>${any2json.version}</version>
</dependency>
<dependency>
    <groupId>com.github.romualdrousseau</groupId>
    <artifactId>any2json-net-classifier</artifactId>
    <version>${any2json.version}</version>
</dependency>
<dependency>
    <groupId>com.github.romualdrousseau</groupId>
    <artifactId>any2json-csv</artifactId>
    <version>${any2json.version}</version>
</dependency>
<dependency>
    <groupId>com.github.romualdrousseau</groupId>
    <artifactId>any2json-excel</artifactId>
    <version>${any2json.version}</version>
</dependency>
```

## Load base model

To parse a document, any2Json needs a model that will contains the parameters required to the parsing. Instead to start
from an empty Model (See [Tutorial 7](tutorial_7.md)), we will start from an existing one and we will adapt it for our
document. You can find a list and details of all models [here](https://github.com/RomualdRousseau/Any2Json-Models/).

The base model, we will use, is "sales-english" that has been trained on 200+ english documents containing distributor
data and with a large range of different layouts.

The base model already recognize some entities such as DATE and NUMBER. We will setup the model to add one new entity
PRODUCTNAME and we will configure a layex to extract the different elements of the documents. You can find more details
about layex [here](white_papers.md).

```java
final var model = Common.loadModelFromGitHub("sales-english");

// Add product name entity to the model

model.getEntityList().add("PRODUCTNAME");
model.getPatternMap().put("\\D+\\dml", "PRODUCTNAME");
model.getPatternMap().put("(?i)((20|19)\\d{2}-(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)-\\d{2})", "DATE");
model.update();

// Add a layex to the model

final var tableParser = new LayexTableParser(
        List.of("v$"),
        List.of("(()(.+$.+$))(()(E.+$)())+(e.+$)"));
model.registerTableParser(tableParser);
```

### Load the document

We load the document by creating a document instance with the model. The hint "Document.Hint.INTELLI_LAYOUT" tell
the document instance that the document has a complex layout. We also add the hint "Document.Hint.INTELLI_TAG" to tell
that the tabular result must be tagged. The recipe "sheet.setCapillarityThreshold(0)" tell the parser engine to extract
the features as ***small*** as possible. The recipe "sheet.setPivotOption(\"WITH_TYPE_AND_VALUE\")" tell to mange the
pivot:

```java
final var file = Common.loadData("document with pivot.xlsx", this.getClass());
try (final var doc = DocumentFactory.createInstance(file, "UTF-8")
        .setModel(model)
        .setHints(EnumSet.of(Document.Hint.INTELLI_LAYOUT))
        .setRecipe(
                "sheet.setCapillarityThreshold(0)",
                "sheet.setPivotOption(\"WITH_TYPE_AND_VALUE\")")) {

    doc.sheets().forEach(s -> Common.addSheetDebugger(s).getTable().ifPresent(t -> {
        Common.printHeaders(t.headers());
        Common.printRows(t.rows());
    }));
}
```

Note that noew we are printing the tags of the headers and not their names.

```bash
2024-03-11 18:50:22 INFO  Common:42 - Loaded model: sales-english
2024-03-11 18:50:22 INFO  Common:59 - Loaded resource: /data/document with pivot.xlsx
2024-03-11 18:50:25 DEBUG Common:86 - Extracting features ...
2024-03-11 18:50:25 DEBUG Common:90 - Generating Layout Graph ...
2024-03-11 18:50:25 DEBUG Common:94 - Assembling Tabular Output ...
============================== DUMP GRAPH ===============================
Sheet1
|- A document very important DATE META(1, 1, 7, 1, 1, 1)
|- |- PRODUCTNAME META(1, 4, 1, 4, 1, 1)
|- |- |- Client DATE #PIVOT? DATA(1, 5, 7, 11, 7, 4) (1)
================================== END ==================================
2024-03-11 18:50:25 DEBUG Common:99 - Done.
A document very                     DATE             PRODUCTNAME                  Client            DATE #PIVOT?        DATE Amount #TYP         DATE Qty #TYPE?
A document very              2023-Mar-02             Product 1ml                     AAA             2023-Jan-01                     100                       1
A document very              2023-Mar-02             Product 1ml                     AAA             2023-Feb-01                     100                       1
A document very              2023-Mar-02             Product 1ml                     AAA             2023-Mar-02                     100                       1
A document very              2023-Mar-02             Product 1ml                     BBB             2023-Jan-01                     100                       1
A document very              2023-Mar-02             Product 1ml                     BBB             2023-Feb-01                     100                       1
A document very              2023-Mar-02             Product 1ml                     BBB             2023-Mar-02                     100                       1
A document very              2023-Mar-02             Product 1ml                     BBB             2023-Jan-01                     300                       3
A document very              2023-Mar-02             Product 1ml                     BBB             2023-Feb-01                     300                       3
A document very              2023-Mar-02             Product 1ml                     BBB             2023-Mar-02                     300                       3
A document very              2023-Mar-02             Product 1ml                     AAA             2023-Jan-01                     100                       1
A document very              2023-Mar-02             Product 1ml                     AAA             2023-Feb-01                     100                       1
A document very              2023-Mar-02             Product 1ml                     AAA             2023-Mar-02                     100                       1
```

On this output, we print out the graph of the document built during the parsing and we can see clearly the relation
between the elements of the spreadsheet and how there are structured in tabular form.

## Conclusion

Congratulations! You have loaded documents using Any2Json.

For more examples of using Any2Json, check out the [tutorials](index.md).