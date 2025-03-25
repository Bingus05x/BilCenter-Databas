# BilCenter-Databas

Detta projekt innehåller en SQL-fil med databaskod för en bilcenter-databas. Repositoryn innehåller även ett ER-diagram som visar relationer mellan tabellerna.

Relationer i databasen:
Kunder - Beställningar (1:Many)
En kund kan göra flera beställningar, men en beställning tillhör bara en kund. KundID som främmande nyckel i Beställningar.

Beställningar - Orderrader (1:Many)
En beställning kan innehålla flera orderrader, men varje orderrad tillhör bara en beställning. Ordernummer som främmande nyckel i Orderrader.

Bilar - Orderrader (1:Many)
En bil kan förekomma i flera orderrader, men varje orderrad refererar till en specifik bil. FordonID som främmande nyckel i Orderrader.

Reservdelar - Reservdelar_i_Ordrar (1:Many)
En reservdel kan ingå i flera orderrader, men varje orderrad refererar till en specifik reservdel.
ReservdelID som främmande nyckel i Reservdelar_i_Ordrar.

Beställningar - Reservdelar_i_Ordrar (1:Many)
En beställning kan innehålla flera reservdelar, men varje post i Reservdelar_i_Ordrar tillhör en beställning. Ordernummer som främmande nyckel i Reservdelar_i_Ordrar.
Ägare - Bilar (1:Many)
En ägare kan ha flera bilar, men en bil tillhör bara en ägare. ÄgareID som främmande nyckel i Bilar.

Bilar - Reservdelar (1:Many)

En bilmodell kan ha flera reservdelar, men en reservdel kan även vara universell.


Reflektion över databasen:
Designval
Databasen är normaliserad enligt tredje normalformen (3NF) för att minimera redundans och säkerställa dataintegritet. Alla tabeller är strukturerade så att de endast innehåller relevant information, och främmande nycklar används för att bevara relationerna mellan entiteterna. Detta möjliggör effektiv hantering av kunder, beställningar, bilar och reservdelar.

Skalbarhet (100 000 kunder)
För att hantera en stor datamängd kan prestandan optimeras genom:
Indexering: På sökbara fält såsom registreringsnummer, e-post och datum för att snabba upp frågor.
Partitionering: Tabeller som "Beställningar" kan delas upp baserat på år för att förbättra prestandan.
Caching: Vanliga frågor kan cachas för att minska onödig belastning på databasen.

Optimeringar
Materialiserade vyer: För att lagra och snabbt hämta ofta använda frågor.
Index och constraints: För att förbättra sökhastighet och garantera datakvalitet.
Transaktioner: Användning av ACID-egenskaper för att säkerställa att insättningar och uppdateringar genomförs korrekt.


