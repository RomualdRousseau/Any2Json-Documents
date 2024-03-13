# Tutorial 7 - Data extraction from PDF

[View source on GitHub](https://github.com/RomualdRousseau/Any2Json-Examples).

This tutoral is a continuation of the [Tutorial 6](tutorial_6.md).

This tutorial will demonstrate how to use [Any2Json](https://github.com/RomualdRousseau/Any2Json) to extract data from
one PDF. The document is not well-formed and very noisy. To demonstrate the usage of this framework, we
will load a document with a somewhat complex layout, as seen here:

![document with noises](images/tutorial7_data.png)

## Setup Any2Json

### Import the packages and setup the main class:

```java
package com.github.romualdrousseau.any2json.examples;

import java.util.EnumSet;
import java.util.List;

import com.github.romualdrousseau.any2json.Document;
import com.github.romualdrousseau.any2json.DocumentFactory;
import com.github.romualdrousseau.any2json.parser.LayexTableParser;

public class Tutorial7 implements Runnable {

    public Tutorial7() {
    }

    @Override
    public void run() {
        // Code will come here
    }

    public static void main(final String[] args) {
        new Tutorial7().run();
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
<dependency>
    <groupId>com.github.romualdrousseau</groupId>
    <artifactId>any2json-pdf</artifactId>
    <version>${any2json.version}</version>
</dependency>
```

## Load base model

To parse a document, any2Json needs a model that will contains the parameters required to the parsing. Instead to start
from an empty Model (See [Tutorial 8](tutorial_8.md)), we will start from an existing one and we will adapt it for our
document. You can find a list and details of all models [here](https://github.com/RomualdRousseau/Any2Json-Models/).

The base model, we will use, is "sales-english" that has been trained on 200+ english documents containing distributor
data and with a large range of different layouts.

The base model already recognize some entities such as DATE and NUMBER. We will configure a layex to extract the
different elements of the documents. You can find more details about layex [here](white_papers.md).

```java
final var model = Common.loadModelFromGitHub("sales-english");

// Add a layex to the model

final var tableParser = new LayexTableParser(
        List.of("(v.$)+"),
        List.of("((.+$)(.+$.+$))(()(.+$)(.+$))+()"));
model.registerTableParser(tableParser);
```

### Load the document

We load the document by creating a document instance with the model. The hint "Document.Hint.INTELLI_LAYOUT" tells
the document instance that the document has a complex layout. WThe recipe "sheet.setCapillarityThreshold(0)" tells the
parser engine to extract the features as ***small*** as possible:

```java
final var file = Common.loadData("document with noises.pdf", this.getClass());
try (final var doc = DocumentFactory.createInstance(file, "UTF-8")
        .setModel(model)
        .setHints(EnumSet.of(Document.Hint.INTELLI_LAYOUT))
        .setRecipe(
            "sheet.setCapillarityThreshold(0)",
            "sheet.dropNullColumns(0.1)",
            "sheet.dropNullRows(0.45)",
            "sheet.dropNullColumns(0.1)")) {
    ...
}
```

### Output the tabular result

Finally, we iterate over the sheets, rows and cells and output the data on the console:

```java
doc.sheets().forEach(s -> Common.addSheetDebugger(s).getTable().ifPresent(t -> {
    Common.printHeaders(t.headers());
    Common.printRows(t.rows());
}));
```

```bash
2024-03-13 16:03:02 INFO  Common:43 - Loaded model: sales-english
2024-03-13 16:03:03 INFO  Common:60 - Loaded resource: /data/document with noises.pdf
2024-03-13 16:03:06 DEBUG Common:87 - Extracting features ...
2024-03-13 16:03:06 DEBUG Common:91 - Generating Layout Graph ...
2024-03-13 16:03:06 DEBUG Common:95 - Assembling Tabular Output ...
============================== DUMP GRAPH ===============================
document with noises
|- BGA Group Of CompaniesBase/400 Stock and Sales/Purchases Report DATE Item DescriptionUnit ON ONCURRCURRLAST YEARYEAR GROWTHCURR CURRLAST GROWTH Sts YEARYEAR DATA(0, 0, 4, 39, 40, 37) (1)
================================== END ==================================
2024-03-13 16:03:06 DEBUG Common:100 - Done.
BGA Group Of Com        Stock and Sales/                    DATE        Item Description                      ON        ONCURRCURRLAST Y              GROWTHCURR        CURRLAST GROWTH 
BGA Group Of Com        Stock and Sales/                 3/02/24        DAFLON TABLETS 5                     107        050487320 + 52 %                  $1,700        $16,558$9,916 + 
BGA Group Of Com        Stock and Sales/                 3/02/24        DIAMICRON MR 60m                      61         01516915 + 27 %                    $750        $8,450$750 + 27 
BGA Group Of Com        Stock and Sales/                 3/02/24        COVERSYL ARGININ                      93             019197195 +                 1 %$484        $4,807$4,582 +5 
BGA Group Of Com        Stock and Sales/                 3/02/24        NATRILIX SR 1.5M                      84        011154215 - 28 %                    $198        $2,772$3,870 - 2
BGA Group Of Com        Stock and Sales/                 3/02/24        PRETERAX 2.5/0.6                       0            01215 - 20 %                      $0        $378$407 -7 % A/
BGA Group Of Com        Stock and Sales/                 3/02/24        PRETERAX 5/1.25m                       5           062637 - 30 %                    $183        $793$1,128 - 30 
BGA Group Of Com        Stock and Sales/                 3/02/24        PRETERAX 10/2.5m                      51                037983 -                 5 %$124        $3,068$3,029 +1 
BGA Group Of Com        Stock and Sales/                 3/02/24        COVERAM 5/5mg TA                      86             024282277 +                 2 %$960        $11,280$11,080 +
BGA Group Of Com        Stock and Sales/                 3/02/24        COVERAM 10/10mg                       94             037292273 +               7 %$1,572        $12,410$11,387 +
BGA Group Of Com        Stock and Sales/                 3/02/24        VALDOXAN 25mg TA                       0            0015 - 100 %                      $0        $0$1,042 - 100 %
BGA Group Of Com        Stock and Sales/                 3/02/24        NATRIXAM 1.5/5mg                       0        08612555 + 127 %                  $1,998        $3,441$1,915 + 8
BGA Group Of Com        Stock and Sales/                 3/02/24        NATRIXAM 1.5/10m                      46               0117375 -                 3 %$374        $2,482$2,550 -3 
BGA Group Of Com        Stock and Sales/                 3/02/24        TRIPLIXAM 10/2.5                      12             000 + 100 %                      $0        $0$0 + 100 % A/A
BGA Group Of Com        Stock and Sales/                 3/02/24        TRIPLIXAM 10/2.5                     105               018235235                 0 %$873        $11,397$11,100 +
BGA Group Of Com        Stock and Sales/                 3/02/24        TRIPLIXAM5/1.25/                      36           044137 + 11 %                    $190        $1,900$1,665 + 1
BGA Group Of Com        Stock and Sales/                 3/02/24        DIAMICRON MR 30m                       0            0310 + 100 %                      $0        $419$0 + 100 % N
BGA Group Of Com        Stock and Sales/                 3/02/24        DIAMICRON MR 30m                       0           00204 - 100 %                      $0        $0$2,775 - 100 %
BGA Group Of Com        Stock and Sales/                 3/02/24        DIAMICRON MR 60m                       0           00345 - 100 %                      $0        $0$8,259 - 100 %
BGA Group Of Com        Stock and Sales/                 3/02/24        SERVIER C.A. Y C                     780        02842,2032,396 -               8 %$9,406        $80,155$75,455 +
```

On this output, we print out the graph of the document built during the parsing and we can see clearly the relation
between the elements of the spreadsheet and how there are structured in tabular form.

## Conclusion

Congratulations! You have loaded documents using Any2Json.

For more examples of using Any2Json, check out the [tutorials](index.md).