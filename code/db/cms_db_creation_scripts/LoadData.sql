/* Load the list of Locales */
 SET IDENTITY_INSERT t_locale ON
insert t_locale ( LocaleID,LocaleActive,LocaleName,LocaleAlias,LocaleCode,LanguageID,GMTOffset,DSTStartDateTime,DSTEndDateTime )  select 1,1,'United States','us','US',100,null,null,null
SET IDENTITY_INSERT t_locale OFF

/* Load the default user list */
 SET IDENTITY_INSERT t_user ON
 insert t_user ( UserID,LocaleID,FirstName,MiddleName,LastName,Title,OrganizationName,UserLogin,UserPassword,EmailAddress,PhoneNumber,DayPhoneNumber,FaxNumber,MailingList,Browser,RemoteHost,DisableRichControls )  select 1,1,'Default','','Administrator','','','administrator','administrator','support@thirdwavellc.com','',null,'',null,null,null,0
 SET IDENTITY_INSERT t_user OFF

/* Load the user group list */
 insert t_usergroup ( UserID,UserGroupID )  select 1,3
 insert t_usergroup ( UserID,UserGroupID )  select 1,4


/* Load the Country List */ 
 SET IDENTITY_INSERT t_Country ON
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 1,'US','United States',10
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 2,'CA','Canada',20
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 3,'AD','Andorra',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 4,'AE','United Arab Emirates',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 5,'AF','Afghanistan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 6,'AG','Antigua And Barbuda',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 7,'AI','Anguilla',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 8,'AL','Albania',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 9,'AM','Armenia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 10,'AN','Netherlands Antilles',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 11,'AO','Angola',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 12,'AQ','Antarctica',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 13,'AR','Argentina',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 14,'AS','American Samoa',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 15,'AT','Austria',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 16,'AU','Australia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 17,'AW','Aruba',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 18,'AZ','Azerbaijan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 19,'BA','Bosnia and Herzegovina',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 20,'BB','Barbados',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 21,'BD','Bangladesh',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 22,'BE','Belgium',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 23,'BF','Burkina Faso',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 24,'BG','Bulgaria',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 25,'BH','Bahrain',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 26,'BI','Burundi',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 27,'BJ','Benin',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 28,'BM','Bermuda',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 29,'BN','Brunei',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 30,'BO','Bolivia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 31,'BR','Brazil',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 32,'BS','Bahamas',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 33,'BT','Bhutan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 34,'BV','Bouvet Island',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 35,'BW','Botswana',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 36,'BY','Belarus',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 37,'BZ','Belize',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 39,'CC','Cocos (Keeling) Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 40,'CD','Dem Rep of Congo (Zaire)',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 41,'CF','Central African Republic',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 42,'CG','Congo',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 43,'CH','Switzerland',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 44,'CI','Cote D''Ivoire (Ivory Coast)',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 45,'CK','Cook Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 46,'CL','Chile',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 47,'CM','Cameroon',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 48,'CN','China',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 49,'CO','Columbia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 50,'CR','Costa Rica',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 51,'CU','Cuba',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 52,'CV','Cape Verde',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 53,'CX','Christmas Island',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 54,'CY','Cyprus',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 55,'CZ','Czech Republic',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 56,'DE','Germany',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 57,'DJ','Djibouti',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 58,'DK','Denmark',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 59,'DM','Dominica',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 60,'DO','Dominican Republic',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 61,'DZ','Algeria',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 62,'EC','Ecuador',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 63,'EE','Estonia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 64,'EG','Egypt',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 65,'EH','Western Sahara',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 66,'ER','Eritrea',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 67,'ES','Spain',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 68,'ET','Ethiopia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 69,'FI','Finland',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 70,'FJ','Fiji',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 71,'FK','Falkland Islands (Malvinas)',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 72,'FM','Micronesia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 73,'FO','Faroe Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 74,'FR','France',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 75,'GA','Gabon',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 76,'GD','Grenada',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 77,'GE','Georgia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 78,'GF','French Guiana',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 79,'GH','Ghana',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 80,'GI','Gibraltar',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 81,'GL','Greenland',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 82,'GM','Gambia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 83,'GN','Guinea',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 84,'GP','Guadeloupe',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 85,'GQ','Equatorial Guinea',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 86,'GR','Greece',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 87,'GS','S Georgia/The S Sandwich Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 88,'GT','Guatemala',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 89,'GU','Guam',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 90,'GW','Guinea-Bissau',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 91,'GY','Guyana',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 92,'HK','Hong Kong SAR, PRC',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 93,'HM','Heard and McDonald Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 94,'HN','Honduras',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 95,'HR','Croatia (Hrvatska)',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 96,'HT','Haiti',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 97,'HU','Hungary',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 98,'ID','Indonesia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 99,'IE','Ireland',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 100,'IL','Israel',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 101,'IN','India',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 102,'IO','British Indian Ocean Territory',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 103,'IQ','Iraq',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 104,'IR','Iran',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 105,'IS','Iceland',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 106,'IT','Italy',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 107,'JM','Jamaica',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 108,'JO','Jordan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 109,'JP','Japan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 110,'KE','Kenya',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 111,'KG','Kyrgyzstan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 112,'KH','Cambodia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 113,'KI','Kiribati',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 114,'KM','Comoros',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 115,'KN','Saint Kitts And Nevis',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 116,'KP','D.P.R. Korea',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 117,'KR','Korea, North',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 118,'KW','Kuwait',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 119,'KY','Cayman Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 120,'KZ','Kazakhstan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 121,'LA','Laos',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 122,'LB','Lebanon',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 123,'LC','Saint Lucia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 124,'LI','Liechtenstein',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 125,'LK','Sri Lanka',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 126,'LR','Liberia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 127,'LS','Lesotho',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 128,'LT','Lithuania',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 129,'LU','Luxembourg',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 130,'LV','Latvia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 131,'LY','Libya',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 132,'MA','Morocco',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 133,'MC','Monaco',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 134,'MD','Moldova',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 135,'MG','Madagascar',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 136,'MH','Marshall Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 137,'MK','Macedonia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 138,'ML','Mali',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 139,'MM','Myanmar',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 140,'MN','Mongolia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 141,'MO','Macao',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 142,'MP','Northern Mariana Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 143,'MQ','Martinique',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 144,'MR','Mauritania',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 145,'MS','Montserrat',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 146,'MT','Malta',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 147,'MU','Mauritius',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 148,'MV','Maldives',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 149,'MW','Malawi',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 150,'MX','Mexico',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 151,'MY','Malaysia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 152,'MZ','Mozambique',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 153,'NA','Namibia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 154,'NC','New Caledonia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 155,'NE','Niger',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 156,'NF','Norfolk Island',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 157,'NG','Nigeria',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 158,'NI','Nicaragua',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 159,'NL','Netherlands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 160,'NO','Norway',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 161,'NP','Nepal',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 162,'NR','Nauru',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 163,'NU','Niue',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 164,'NZ','New Zealand',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 165,'OM','Oman',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 166,'PA','Panama',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 167,'PE','Peru',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 168,'PF','French Polynesia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 169,'PG','Papua new Guinea',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 170,'PH','Philippines',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 171,'PK','Pakistan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 172,'PL','Poland',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 173,'PM','St Pierre and Miquelon',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 174,'PN','Pitcairn',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 175,'PR','Puerto Rico',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 176,'PT','Portugal',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 177,'PW','Palau',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 178,'PY','Paraguay',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 179,'QA','Qatar',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 180,'RE','Reunion',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 181,'RO','Romania',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 182,'RU','Russia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 183,'RW','Rwanda',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 184,'SA','Saudi Arabia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 185,'SB','Solomon Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 186,'SC','Seychelles',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 187,'SD','Sudan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 188,'SE','Sweden',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 189,'SG','Singapore',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 190,'SH','St Helena',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 191,'SI','Slovenia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 192,'SJ','Svalbard And Jan Mayen Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 193,'SK','Slovak Republic',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 194,'SL','Sierra Leone',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 195,'SM','San Marino',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 196,'SN','Senegal',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 197,'SO','Somalia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 198,'SR','Suriname',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 199,'ST','Sao Tome and Principe',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 200,'SV','El Salvador',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 201,'SY','Syria',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 202,'SZ','Swaziland',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 203,'TC','Turks And Caicos Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 204,'TD','Chad',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 205,'TF','French Southern Territories',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 206,'TG','Togo',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 207,'TH','Thailand',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 208,'TJ','Tajikistan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 209,'TK','Tokelau',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 210,'TM','Turkmenistan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 211,'TN','Tunisia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 212,'TO','Tonga',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 213,'TP','East Timor',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 214,'TR','Turkey',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 215,'TT','Trinidad And Tobago',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 216,'TV','Tuvalu',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 217,'TW','Taiwan, ROC',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 218,'TZ','Tanzania',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 219,'UA','Ukraine',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 220,'UG','Uganda',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 221,'UK','United Kingdom',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 222,'UM','U.S. Minor Outlying Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 224,'UY','Uruguay',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 225,'UZ','Uzbekistan',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 226,'VA','Vatican City State (Holy See)',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 227,'VC','Saint Vincent And The Grenadines',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 228,'VE','Venezuela',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 229,'VG','Virgin Islands (British)',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 230,'VI','Virgin Islands (US)',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 231,'VN','Vietnam',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 232,'VU','Vanuatu',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 233,'WF','Wallis And Futuna Islands',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 234,'WS','Samoa',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 235,'YE','Yemen',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 236,'YT','Mayotte',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 237,'YU','Yugoslavia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 238,'ZA','South Africa',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 239,'ZM','Zambia',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 240,'ZW','Zimbabwe',null
 insert t_Country ( CountryID,CountryCode,CountryName,Priority )  select 241,'KS','Korea, South',null
SET IDENTITY_INSERT t_Country OFF 

/* Load the Label List */
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 3,'UGRP','Content Editor',10,3,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 4,'UGRP','Administrator',10,4,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 20,'TTYP','Content',20,1,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 22,'TEMTYP','Pop-up',200,3,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 33,'TrackType','Null Search Terms',900,1,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 34,'TrackStatus','New',1000,1,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 35,'TrackStatus','Disregard',1000,2,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 36,'TrackStatus','Resolved',1000,3,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 37,'TrackType','Search Terms',900,2,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 60,'3WCAT','Content',40,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 61,'3WCAT','System',40,120,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 65,'3WCAT','Site',40,60,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 66,'3WCAT','Article',-40,70,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 67,'3WCAT','News List',40,80,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 68,'3WCAT','Questions & Answers',-40,90,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 69,'3WCAT','Press Release',-40,100,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 70,'3wCAT','Biography',-40,110,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 71,'3WCAT','Event List',40,130,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 72,'3WCAT','Resource',-40,120,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 73,'3WCAT','Gallery',-40,140,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 74,'3WCAT','Banner Repository',40,150,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 75,'3WCAT','MT Blog ',-40,20,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 100,'EN','English',60,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 101,'ES','Spanish',60,20,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 102,'DE','German',60,30,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 103,'FR','French',60,40,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 104,'PT','Portuguese',60,50,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 105,'IT','Italian',60,60,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 106,'JP','Japanese',60,70,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 107,'ZH','Simplified Chinese',60,80,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 108,'NL','Dutch',60,90,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 200,'CONTTYP','Text',70,20,'/common/images/ContentManager/icon_content.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 201,'CONTTYP','HTML',70,10,'/common/images/ContentManager/icon_content.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 202,'CONTTYP','HTML and Text',-70,40,'/common/images/ContentManager/icon_content.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 203,'CONTTYP','HTML Template',-70,60,'/common/images/ContentManager/icon_content.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 204,'CONTTYP','Teaser',-70,80,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 205,'CONTTYP','Article',-70,90,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 206,'CONTTYP','Repeated Content',70,110,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 207,'CONTTYP','Inheirited',-70,100,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 208,'CONTTYP','Contact Form',-70,140,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 209,'CONTTYP','Resource Link',-70,120,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 210,'CONTTYP','Resource Version',-70,130,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 212,'CONTTYP','Image',70,70,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 213,'CONTTYP','Image Index Navigation',-70,170,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 214,'CONTTYP','Article List Teaser',-70,93,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 215,'CONTTYP','Review List Teaser',-70,190,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 216,'CONTTYP','Article List',-70,91,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 217,'CONTTYP','Bullet List',70,30,'/common/images/ContentManager/icon_content.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 218,'CONTTYP','Flash',70,80,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 219,'CONTTYP','Submit Success Story',-70,200,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 220,'CONTTYP','Question List',-70,210,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 221,'CONTTYP','News Item',-70,100,'/common/images/ContentManager/icon_content.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 222,'CONTTYP','List of Files',-70,220,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 223,'CONTTYP','Windowed External Site',-70,110,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 224,'CONTTYP','Press Release List',-70,240,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 225,'CONTTYP','Biography Listing',-70,250,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 226,'CONTTYP','Event',-70,260,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 227,'CONTTYP','Event List',-70,270,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 228,'CONTTYP','News List',-70,120,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 229,'CONTTYP','Showcase Navigation',-70,280,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 230,'CONTTYP','Related Article List',-70,92,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 231,'CONTTYP','List of Recent Pages/Resources',-70,40,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 232,'CONTTYP','Index of Sub Pages',70,50,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 233,'CONTTYP','Content Template',70,140,'/common/images/ContentManager/icon_teaser.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 234,'CONTTYP','Templatized Content',70,40,'/common/images/ContentManager/icon_content.gif',null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 235,'CONTTYP','Event',-70,150,'/common/images/ContentManager/icon_content.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 236,'CONTTYP','Event Listing',-70,170,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 237,'CONTTYP','Recent Event Listing',-70,180,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 238,'CONTTYP','Event Calendar',-70,190,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 239,'CONTTYP','Event iCal Download',-70,200,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 240,'CONTTYP','Event Detail',-70,160,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 241,'CONTTYP','RSS Feed',70,90,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 242,'CONTTYP','Jobs Search',-70,210,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 243,'CONTTYP','Jobs Detail',-70,220,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 244,'CONTTYP','Recent Job Listing',-70,240,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 245,'CONTTYP','Banner',70,130,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 246,'CONTTYP','Job Listing',70,230,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 247,'CONTTYP','HTTP Get',70,250,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 248,'CONTTYP','Recent Comments',-70,260,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 249,'CONTTYP','Gallery Thumbnail Navigation',-70,270,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 250,'CONTTYP','Gallery Display',-70,265,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 251,'CONTTYP','Event Registration',-70,205,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 252,'CONTTYP','Recent Discussions',-70,262,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 253,'CONTTYP','Newsletter Subscribe/Unsubscribe',-70,280,'/common/images/ContentManager/icon_teaser.gif',0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 300,'WFSTAT','Submitted',80,null,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 400,'CONTPOS','Left',90,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 401,'CONTPOS','Center',90,20,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 402,'CONTPOS','Right',90,30,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 403,'CONTPOS','Preview',90,40,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 500,'create','Created',100,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 501,'modify','Modified',100,20,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 502,'open','Opened',100,30,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 503,'savelive','Saved to Production',100,40,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 506,'delete','Deleted',100,50,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 507,'touch','Touched',100,60,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 700,'FEEDST','New',700,1,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 701,'FEEDST','Received',700,11,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 702,'FEEDST','Resolved',700,21,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1200,'TITLETYPE','Hidden',170,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1201,'TITLETYPE','Header 1',170,20,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1202,'TITLETYPE','Header 2',170,30,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1203,'TITLETYPE','Header 3',170,40,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1204,'TITLETYPE','Header 4',170,50,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1205,'TITLETYPE','Header 5',170,60,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1206,'TITLETYPE','Header 6',170,70,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1400,'NAVTYPE','Sub Pages',190,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1401,'NAVTYPE','Sibling Pages',190,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1500,'TEMTYP','Default',200,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1501,'TEMTYP','Full Width',200,20,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1700,'LISTTYP','Show All',220,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1701,'LISTTYP','Show By Section',220,20,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1800,'INHERIT','This page only',230,10,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1801,'INHERIT','All sub-pages',230,20,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1802,'INHERIT','All sub-pages and hide on this page',230,30,null,null
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 1803,'INHERIT','All Sub-Pages with No Content in this Position',-230,40,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 2000,'NAVOPT','Future',2000,10,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 2001,'NAVOPT','Recent',2000,20,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 2100,'DISPMOD','Default',2100,10,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 2101,'DISPMOD','Compact',2100,20,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 6000,'OS','Windows',6000,10,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 6001,'OS','Mac OS',6000,20,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 6002,'OS','Other',6000,30,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 7000,'SPPRTSTS','Open',7000,10,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 7001,'SPPRTSTS','Pending',7000,20,null,0
 insert t_label ( LabelID,LabelCode,LabelName,LabelGroupID,LabelPriority,LabelImage,LabelParent )  select 7002,'SPPRTSTS','Closed',7000,30,null,0

/* Load the MIME types */
SET IDENTITY_INSERT t_mime ON
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 1,80,'plain','Plain text','/common/images/icons/txt.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 2,80,'richtext','Rich text format','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 3,80,'enriched','Enriched text format','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 4,80,'html','Hypertext markup language','/common/images/icons/html1.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 5,80,'vnd.wap.wml','WML deck','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 6,80,'vnd.wap.wmlscript','WML script ','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 7,81,'jpeg','JPEG image','/common/images/icons/jpg.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 8,81,'gif','Compuserve image format','/common/images/icons/gif.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 9,81,'png','PNG image','/common/images/icons/png.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 10,81,'vnd.wap.wbmp','WBMP image','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 11,82,'basic','ULAW audio data','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 12,83,'mpeg','MPEG video','/common/images/icons/mpeg.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 13,84,'octet-stream','Binary executable','/common/images/icons/exe.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 14,84,'postscript','Postscript program','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 15,84,'pdf','Portable document format','/common/images/icons/pdf.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 16,84,'vnd.wap.wmlc','Compiled WML deck','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 17,84,'vnd.wap.wmlscriptc','Compiled WML script','/common/images/icons/default.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 18,84,'msword','Microsoft Word','/common/images/icons/doc.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 19,84,'mspowerpoint','Microsoft PowerPoint','/common/images/icons/ppt.gif'
 insert t_mime ( MimeID,MimeMediaTypeID,MimeSubtype,MimeDescription,MimeIconPath )  select 20,84,'msexcel','Microsoft Excel','/common/images/icons/xls.gif'
SET IDENTITY_INSERT t_mime OFF

/* Load the MIME extensions */
SET IDENTITY_INSERT t_mimeextensions ON
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 1,1,'txt'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 2,1,'text'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 3,2,'rtf'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 4,3,'etf'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 5,4,'html'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 6,4,'htm'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 7,5,'wml'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 8,6,'wmls'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 9,7,'jpeg'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 10,7,'jpg'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 11,7,'jpe'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 12,8,'gif'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 13,9,'png'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 14,10,'wbmp'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 15,11,'au'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 16,11,'snd'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 17,12,'mpeg'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 18,12,'mpg'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 19,12,'mpe'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 20,13,'exe'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 21,13,'bin'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 22,14,'ai'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 23,14,'eps'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 24,14,'ps'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 25,15,'pdf'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 26,16,'wmlc'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 27,17,'wmlsc'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 28,18,'doc'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 29,19,'ppt'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 30,20,'xls'
 insert t_mimeextensions ( MimeExtID,MimeID,MimeExtension )  select 31,20,'xlt'
SET IDENTITY_INSERT t_mimeextensions OFF

/* Load the States and Provinces Table */
SET IDENTITY_INSERT t_stateprovince ON
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 4,'AK','Alaska','US',20
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 5,'AL','Alabama','US',10
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 6,'AR','Arkansas','US',40
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 7,'AZ','Arizona','US',30
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 8,'CA','California','US',50
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 9,'CO','Colorado','US',60
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 10,'CT','Connecticut','US',70
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 11,'DC','District of Columbia','US',90
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 12,'DE','Delaware','US',80
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 13,'FL','Florida','US',100
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 14,'GA','Georgia','US',110
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 15,'HI','Hawaii','US',120
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 16,'IA','Iowa','US',160
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 17,'ID','Idaho','US',130
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 18,'IL','Illinois','US',140
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 19,'IN','Indiana','US',150
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 20,'KS','Kansas','US',170
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 21,'KY','Kentucky','US',180
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 22,'LA','Louisiana','US',190
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 23,'MA','Massachusetts','US',220
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 24,'MD','Maryland','US',210
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 25,'ME','Maine','US',200
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 26,'MI','Michigan','US',230
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 27,'MN','Minnesota','US',240
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 28,'MO','Missouri','US',260
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 29,'MS','Mississippi','US',250
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 30,'MT','Montana','US',270
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 31,'NC','North Carolina','US',340
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 32,'ND','North Dakota','US',350
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 33,'NE','Nebraska','US',280
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 34,'NH','New Hampshire','US',300
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 35,'NJ','New Jersey','US',310
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 36,'NM','New Mexico','US',320
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 37,'NV','Nevada','US',290
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 38,'NY','New York','US',330
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 39,'OH','Ohio','US',360
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 40,'OK','Oklahoma','US',370
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 41,'OR','Oregon','US',380
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 42,'PA','Pennsylvania','US',390
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 43,'RI','Rhode Island','US',400
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 44,'SC','South Carolina','US',410
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 45,'SD','South Dakota','US',420
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 46,'TN','Tennessee','US',430
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 47,'TX','Texas','US',440
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 48,'UT','Utah','US',450
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 49,'VA','Virginia','US',470
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 50,'VT','Vermont','US',460
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 51,'WA','Washington','US',480
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 52,'WI','Wisconsin','US',500
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 53,'WV','West Virginia','US',490
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 54,'WY','Wyoming','US',510
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 55,'AB','Alberta','CA',1010
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 56,'BC','British Columbia','CA',1020
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 57,'MB','Manitoba','CA',1030
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 58,'NB','New Brunswick','CA',1040
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 59,'NF','Newfoundland','CA',1050
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 60,'NS','Nova Scotia','CA',1060
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 61,'NT','Northwest Territories','CA',1070
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 62,'NU','Nunavut','CA',1080
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 63,'ON','Ontario','CA',1090
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 64,'PE','Prince Edward Island','CA',1100
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 65,'QC','Quebec','CA',1110
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 66,'SK','Saskatchewan','CA',1120
 insert t_stateprovince ( StateProvinceID,StateProvinceCode,StateProvinceName,CountryCode,Priority )  select 67,'YT','Yukon','CA',1130
SET IDENTITY_INSERT t_stateprovince OFF



/* load the system messages */
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-noRedirectType','Error','Unable to update url redirect - no matching redirect type.')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-noRedirect','Error','The requested url redirect doesn''t exist')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-updateFailed','Error','Unable to update url redirect - update failed')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-emptySourceUrl','Error','You may not pass an empty source url for this type')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-emptyDestinationUrl','Error','You may not pass an empty destination url for this type')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-noSlashSource','Error','Source url must be a root relative path, starting with "/"')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-noDestinationSlash','Error','Destination url must be a root relative path, starting with "/"')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-sourceOrDestinationNotUnique','Error','Both source and destination urls must be unique for this type')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-sourceNotUnique','Error','Source url must be unique for this type')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-destinationNotUnique','Error','Destination url must be unique for this type')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-addFailed','Error','Unable to add url redirect - insert failed')
insert t_message (messageKey, messageLabel, message) values ('urlRewrite-redirectDeleted',null,'Url redirect deleted')


