## 24. Primitive Types
boolean
byte
char
short
int
long
float
double

```
package academy.learnprogramming;

public class Main {

    public static void main(String[] args) {
        int myValue = 10000;
        int myMinIntValue = Integer.MIN_VALUE;
        int myMaxIntValue = Integer.MAX_VALUE;
        System.out.println( "Integer Minimum Value = " + myMinIntValue);
        System.out.println( "Integer Maximum Value = " + myMaxIntValue);
        System.out.println("Busted MAX Value = " + (myMaxIntValue + 1));
        System.out.println("Busted MIN Value = " + (myMinIntValue-1));
        int myMaxIntTest = 2_147_483_647;
        <!-- work for java 7 version higher -->
        System.out.println(myMaxIntTest);
    }
}
```
```log
"C:\Program Files\Amazon Corretto\jdk11.0.6_10\bin\java.exe" "-javaagent:C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2019.3.2\lib\idea_rt.jar=5459:C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2019.3.2\bin" -Dfile.encoding=UTF-8 -classpath C:\Users\marsforever\JavaProMasterSoftDev\ByteShortIntLong\out\production\ByteShortIntLong academy.learnprogramming.Main
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF8
Integer Minimum Value = -2147483648
Integer Maximum Value = 2147483647
Busted MAX Value = -2147483648
Busted MIN Value = 2147483647
2147483647

Process finished with exit code 0
```

