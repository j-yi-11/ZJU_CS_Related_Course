# define _CRT_SECURE_NO_WARNINGS
# include <winsock.h>
# include <mysql.h>
# include <iostream>
# include <fstream>
# include <string>
# include <cstdlib>
# include <cstdio>
# define OnlyCheckBooks 0
# define AdminLogin 1
# define bookID 0
# define type 1
# define bookName 2
# define publisher 3
# define publishYear 4
# define author 5
# define price 6
# define totalNum 7
# define storageNum 8
# define updateTime 9
# define ascend 0
# define descend 1
# define exitLogin -1
# define booksIn 0
# define borrowBooks 1
# define returnBooks 2
# define cardManage 3
# define OneBook 0
# define ManyBooks 1
# define DeleteOneKind 2
# define AddCard 0
# define DeleteCard 1
# define NULLRepresent "null"
# define Accurate 0
# define Fuzzy 1
# define Range 2
using namespace std;
MYSQL mysql;
const char* host = "localhost";
const char* user = "root";
const char* password = ;
const char* database = "test";
const int port = 3306;
int mode;
void set(string& s)
{
	if (s == "null")
	{
		s = "null";
	}
	else {
		s = "'" + s + "'";
	}
}
void sortPartialBooksByOrder(MYSQL_RES* result, string condition)/*partial books*/
{
	int DoSort = 0;
	int sorttype = 0;
	int order = 0;/*order == 0; ascend   order == 1;descend*/
	printf("input partially sort or not\n0:no sort and break directly\n1:partially sort\n");
	cin >> DoSort;//scanf("%d", &DoSort);
	string sql = "select * from `books` order by ";
	while (DoSort == 1)
	{
		sql = "select * from `books`" + condition + " order by ";
		if (result)
		{
			printf("input type of sort\n0:bookID\n1:type\n2:bookName\n3:publisher\n4:publishYear\n5:author\n6:price\n7:totalNum\n8:storageNum\n9:updateTime\n");
			cin >> sorttype;//scanf("%d", &sorttype);
			printf("input type of order\n0:asc\n1:desc\n");
			cin >> order;//scanf("%d", &order);
			switch (sorttype)
			{
				case bookID: sql += "bookID "; break;
				case type:sql += "type "; break;
				case bookName:sql += "bookName "; break;
				case publisher:sql += "publisher "; break;
				case publishYear:sql += "publishYear "; break;
				case author:sql += "author "; break;
				case price:sql += "price "; break;
				case totalNum:sql += "totalNum "; break;
				case storageNum:sql += "storageNum "; break;
				case updateTime:sql += "updateTime "; break;
				default:break;
			}
			if (order == ascend) sql += "ASC;";
			else if (order == descend) sql += "DESC;";
			int query = mysql_query(&mysql, sql.c_str());
			if (query == 0){
				MYSQL_RES* partialResult = mysql_store_result(&mysql);
				if (partialResult){
					unsigned long partialNumber = (unsigned long)mysql_num_rows(partialResult);
					cout << "number of books selected:" << partialNumber << endl;
					MYSQL_FIELD* fd = mysql_fetch_field(partialResult);
					while (fd){
						cout << fd->name << "   ";
						fd = mysql_fetch_field(partialResult);
					}
					cout << endl;
					MYSQL_ROW row;
					while (row = mysql_fetch_row(partialResult)){
						unsigned long* lens = mysql_fetch_lengths(partialResult);
						for (int i = 0; i < mysql_num_fields(partialResult); ++i)
							if (row[i]) cout << row[i] << "\t";
							else cout << "NULL";
						cout << endl;
					}
				}
				mysql_free_result(partialResult);
			}
		}
		cout << "input sort or not\n0:no sort and break directly\n1:sort\n";
		cin >> DoSort;//scanf("%d", &DoSort);
	}
	return;
}
void sortAllBooksByOrder(MYSQL_RES* result)/*all books*/
{
	int DoSort = 0;
	int sorttype = 0;
	int order = 0;/*order == 0; ascend   order == 1;descend*/
	printf("input sort or not\n0:no sort and break directly\n1:sort\n");
	cin >> DoSort;
	string sql = "select * from `books` order by ";
	while (DoSort == 1){
		sql = "select * from `books` order by ";
		if (result)
		{
			printf("input type of sort\n0:bookID\n1:type\n2:bookName\n3:publisher\n4:publishYear\n5:author\n6:price\n7:totalNum\n8:storageNum\n9:updateTime\n");
			cin >> sorttype;//scanf("%d", &sorttype);
			printf("input type of order\n0:asc\n1:desc\n");
			cin >> order;//scanf("%d", &order);
			switch (sorttype)
			{
				case bookID: sql += "bookID ";break;
				case type:sql += "type ";break;
				case bookName:sql += "bookName ";break;
				case publisher:sql += "publisher ";break;
				case publishYear:sql += "publishYear ";break;
				case author:sql += "author ";break;
				case price:sql += "price ";break;
				case totalNum:sql += "totalNum ";break;
				case storageNum:sql += "storageNum ";break;
				case updateTime:sql += "updateTime ";break;
				default:break;
			}
			if (order == ascend) sql += "ASC;";
			else if (order == descend) sql += "DESC;";
			int query = mysql_query(&mysql, sql.c_str());
			if (query == 0)
			{
				MYSQL_RES* partialResult = mysql_store_result(&mysql);
				if (partialResult)
				{
					unsigned long partialNumber = (unsigned long)mysql_num_rows(partialResult);
					cout << "number of books selected:" << partialNumber << endl;
					MYSQL_FIELD* fd = mysql_fetch_field(partialResult);
					while (fd)
					{
						cout << fd->name << "   ";
						fd = mysql_fetch_field(partialResult);
					}
					cout << endl;
					MYSQL_ROW row;
					while (row = mysql_fetch_row(partialResult))
					{
						unsigned long* lens = mysql_fetch_lengths(partialResult);
						for (unsigned int i = 0; i < mysql_num_fields(partialResult); ++i)
							if (row[i]) cout << row[i] << "\t";
							else cout << "NULL";
						cout << endl;
					}
				}
				mysql_free_result(partialResult);
			}
		}
		printf("input sort or not\n0:no sort and break directly\n1:sort\n");
		cin >> DoSort;//scanf("%d", &DoSort);
	}
	return;
}
void OnlyViewBooks()
{
	int bookres = mysql_query(&mysql, "select * from `books`");
	if (bookres == 0)/*successful query*/
	{
		MYSQL_RES* bookResult = mysql_store_result(&mysql);
		int selectedType = 0;
		if (bookResult)
		{
			unsigned long bookNumber = (unsigned long)mysql_num_rows(bookResult);
			cout << "number of books:" << bookNumber << endl;
			MYSQL_FIELD* fd = mysql_fetch_field(bookResult);
			while (fd)
			{
				cout << fd->name << "\t"; fd = mysql_fetch_field(bookResult);
			}
			cout << endl;
			MYSQL_ROW row;
			while (row = mysql_fetch_row(bookResult))
			{
				unsigned long* lens = mysql_fetch_lengths(bookResult);
				for (int i = 0; i < mysql_num_fields(bookResult); ++i)
					if (row[i]) cout << row[i] << "\t";
					else cout << "NULL    " << "\t";
				cout << endl;
			}
			sortAllBooksByOrder(bookResult);

			int conditionNumber = 0, id = -1;
			cout << "Please input the number of conditions" << endl; cin >> conditionNumber;
			string sql = "select * from `books` where ", condition = " where ";
			string information, upperBound, lowBound;			
			if (conditionNumber == 1)
			{
				printf("input type of partial select \n0: bookID\n1:type\n2:bookName\n3:publisher\n4:publishYear\n5:author\n6:price\n7:totalNum\n8:storageNum\n9:updateTime\n");
				cin >> selectedType;
				int checkMode = Accurate;
				switch (selectedType)
				{
					case bookID:sql += "bookID = ";printf("input bookID:\n");
						cin >> information;
						sql += information + ";";
						condition += "bookID = ";
						condition += information;
						break;
					case type:sql += "type = ";printf("input type:\n");
						cin >> information;
						sql += "'" + information + "';";
						condition += "type = ";
						condition += " '" + information + "' ";
						break;
					case bookName:
						cout << "Please input check mode:" << endl << "0:accurate check" << endl << "1:fuzzy check" << endl;
						cin >> checkMode;
						if(checkMode == Accurate)
						{
							sql += "bookName = ";printf("input bookName:\n");
							cin >> information;
							sql += "'" + information + "';";
							condition += "bookName = ";
							condition += " '" + information + "' ";
						}
						else if (checkMode == Fuzzy)
						{
							sql += "bookName like"; printf("input bookName:\n");
							cin >> information;
							sql += "'" + information + "';";
							condition += "bookName like ";
							condition += " '" + information + "' ";
						}
						break;
					case publisher:
						cout << "Please input check mode:" << endl << "0:accurate check" << endl << "1:fuzzy check" << endl;
						cin >> checkMode;
						if (checkMode == Accurate)
						{
							sql += "publisher = ";printf("input publisher:\n");
							cin >> information;
							sql += information + ";";
							condition += "publisher = ";
							condition += "'" + information + "' ";
						}
						else if (checkMode == Fuzzy)
						{
							sql += "publisher like "; printf("input publisher:\n");
							cin >> information;
							sql += information + ";";
							condition += "publisher like ";
							condition += "'" + information + "' ";
						}
						break;
					case publishYear:
						cout << "Please input check mode:" << endl << "0:accurate check" << endl << "2:range check" << endl;
						cin >> checkMode;
						if (checkMode == Accurate)
						{
							sql += "publishYear = ";printf("input publishYear:\n");
							cin >> information;
							sql += information + ";";
							condition += "publishYear = ";
							condition += information ;
						}
						else if (checkMode == Range)
						{
							sql += "publishYear BETWEEN "; 
							printf("input low and upper bounds of publishYear seperated by space:\n");
							cin >> lowBound >> upperBound;
							sql += lowBound + " AND " + upperBound + ";";
							condition += "publishYear BETWEEN " + lowBound + " AND " + upperBound + ";";
						}
						break;
					case author:
						cout << "Please input check mode:" << endl << "0:accurate check" << endl << "1:fuzzy check" << endl;
						cin >> checkMode;
						if (checkMode == Accurate)
						{
							sql += "author = ";
							printf("input author:\n");
							cin >> information;
							sql += "'" + information + "';";
							condition += "author = ";
							condition += "'" + information + "' ";
						}
						else if (checkMode == Fuzzy)
						{
							sql += "author like "; 
							printf("input author:\n");
							cin >> information;
							sql += "'" + information + "';";
							condition += "author like ";
							condition += "'" + information + "' ";
						}
						break;
					case price:
						cout << "Please input check mode:" << endl << "0:accurate check" << endl << "2:range check" << endl;
						cin >> checkMode;
						if (checkMode == Accurate)
						{
							sql += "price = ";
							printf("input price:\n");
							cin >> information;
							sql += information + ";";
							condition += "price = ";
							condition += information;
						}
						else if (checkMode == Range)
						{
							sql += "price BETWEEN ";
							printf("input low and upper bounds of price seperated by space:\n");
							cin >> lowBound >> upperBound;
							sql += lowBound + " AND " + upperBound + ";";
							condition += "price BETWEEN " + lowBound + " AND " + upperBound + ";";
						}
						break;
					case totalNum:
						cout << "Please input check mode:" << endl << "0:accurate check" << endl << "2:range check" << endl;
						cin >> checkMode;
						if (checkMode == Accurate)
						{
							sql += "totalNum = ";
							printf("input totalNum:\n");
							cin >> information;
							sql += information + ";";
							condition += "totalNum = ";
							condition += information;
						}
						else if (checkMode == Range)
						{
							sql += "totalNum BETWEEN ";
							printf("input low and upper bounds of totalNum seperated by space:\n");
							cin >> lowBound >> upperBound;
							sql += lowBound + " AND " + upperBound + ";";
							condition += "totalNum BETWEEN " + lowBound + " AND " + upperBound + ";";
						}
						break;
					case storageNum:
						cout << "Please input check mode:" << endl << "0:accurate check" << endl << "2:range check" << endl;
						cin >> checkMode;
						if (checkMode == Accurate)
						{
							sql += "storageNum = ";
							printf("input storageNum:\n");
							cin >> information;
							sql += information + ";";
							condition += "storageNum = ";
							condition += information;
						}
						else if (checkMode == Range)
						{
							sql += "storageNum BETWEEN ";
							printf("input low and upper bounds of storageNum seperated by space:\n");
							cin >> lowBound >> upperBound;
							sql += lowBound + " AND " + upperBound + ";";
							condition += "storageNum BETWEEN " + lowBound + " AND " + upperBound + ";";
						}
						break;
					case updateTime:
						cout << "Please input check mode:" << endl << "0:accurate check" << endl << "2:range check" << endl;
						cin >> checkMode;
						if (checkMode == Accurate)
						{
							sql += "timestamp(updateTime) = ";
							printf("input updateTime:\n");
							condition += "updateTime = ";
							cin >> information; sql += "'" + information + " ";
							condition += "'" + information + " ";
							cin >> information;
							sql += information + "';";
							condition += information + "' ";
						}
						else if (checkMode == Range)
						{
							sql += "updateTime BETWEEN '";
							printf("input low and upper bounds of updateTime seperated by space:\n");
							cin >> lowBound >> upperBound;
							sql += lowBound + "' AND '" + upperBound + "';";
							condition += "updateTime BETWEEN '" + lowBound + "' AND '" + upperBound + "';";
						}
						break;
					default:
						break;
				}
			}
			else {
				while (conditionNumber)
				{
					printf("input type of partial select:\n1:type\n2:bookName\n3:publisher\n4:publishYear\n5:author\n6:price\n");
					cin >> id;
					if ((id != type) && (id != bookName) && (id != publisher) && (id != publishYear) && (id != author) && (id != price))
						continue;
					switch (id)
					{
						case type:
							cout << "Please input type(accurate check)" << endl;
							cin >> information;
							sql += " (type = '" + information + "') ";
							condition += " (type = '" + information + "') ";
							break;
						case bookName:
							cout << "Please input bookName(fuzzy check)" << endl;
							cin >> information;
							sql += " (bookName like '" + information + "') ";
							condition += " (bookName like '" + information + "') ";
							break;
						case publisher:
							cout << "Please input publisher(fuzzy check)" << endl;
							cin >> information;
							sql += " (publisher like '" + information + "') ";
							condition += " (publisher like '" + information + "') ";
							break;
						case publishYear:
							cout << "Please input low and upper bound of publishYear(range check) by space" << endl;
							cin >> lowBound >> upperBound;
							sql += " (publishYear BETWEEN " + lowBound + " AND " + upperBound + ") ";
							condition += " (publishYear BETWEEN " + lowBound + " AND " + upperBound + ") ";
							break;
						case author:
							cout << "Please input author(fuzzy check)" << endl;
							cin >> information;
							sql += " (author like '" + information + "') ";
							condition += " (author like '" + information + "') ";
							break;
						case price:
							cout << "Please input low and upper bound of price(range check) by space" << endl;
							cin >> lowBound >> upperBound;
							sql += " (price BETWEEN " + lowBound + " AND " + upperBound + ") ";
							condition += " (price BETWEEN " + lowBound + " AND " + upperBound + ") ";
							break;
					}
					if (conditionNumber != 1)
					{
						sql += " AND ";
						condition += " AND ";
					}
					conditionNumber--;
				}
				//sql += ";"; condition += ";";
			}


			int query = mysql_query(&mysql, sql.c_str());
			if (query == 0)
			{
				MYSQL_RES* partialResult = mysql_store_result(&mysql);
				if (partialResult)
				{
					unsigned long partialNumber = (unsigned long)mysql_num_rows(partialResult);
					cout << "number of books selected:" << partialNumber << endl;
					MYSQL_FIELD* fd = mysql_fetch_field(partialResult);
					while (fd)
					{
						cout << fd->name << "   ";
						fd = mysql_fetch_field(partialResult);
					}
					cout << endl;
					MYSQL_ROW row;
					while (row = mysql_fetch_row(partialResult))
					{
						unsigned long* lens = mysql_fetch_lengths(partialResult);
						for (int i = 0; i < mysql_num_fields(partialResult); ++i)
							if (row[i]) cout << row[i] << "\t";
							else cout << "NULL";
						cout << endl;
					}
					sortPartialBooksByOrder(partialResult,condition);
				}
				mysql_free_result(partialResult);
			}
			else {
				cout << "error";
			}
		}
		mysql_free_result(bookResult);
	}
}
void output(MYSQL_RES *result)
{
	if (result)
	{
		unsigned long Number = (unsigned long)mysql_num_rows(result);
		cout << "number of selection:" << Number << endl;
		MYSQL_FIELD* fd = mysql_fetch_field(result);
		while (fd)
		{
			cout << fd->name << "   ";fd = mysql_fetch_field(result);
		}
		cout << endl;
		MYSQL_ROW row;
		while (row = mysql_fetch_row(result))
		{
			unsigned long* lens = mysql_fetch_lengths(result);
			for (int i = 0; i < mysql_num_fields(result); ++i)
				if (row[i]) cout << row[i] << "\t";
				else cout << "NULL" << "\t";
			cout << endl;
		}
	}
}
void dealWithOneBookIn(string &BookID , string &Type, string &BookName, 
						string& Publisher, string &PublishYear, string &Author
						, string& Price, string &Num)
{
	string sql = "select * from `books` where ((bookID = "
		+ BookID + ") and (bookName = '" + BookName + "')";
	if (Type != NULLRepresent) sql += " and (type is null or type = '" + Type + "')";
	if (Publisher != NULLRepresent) sql += " and (publisher is null or publisher = '" + Publisher + "')";
	if (PublishYear != NULLRepresent) sql += " and (publishYear is null or publishYear = " + PublishYear + ")";
	if (Author != NULLRepresent) sql += " and (author is null or author = '" + Author + "')";
	if (Price != NULLRepresent) sql += " and (price is null or price = " + Price + ")";
	sql += ");";
	/*
		+ " and (type is null or type = " + "'" + Type + "')"
		+ " and (publisher is null or publisher = " + "'" + Publisher + "')"
		+ " and (publishYear is null or publishYear = " + PublishYear + ")"
		+ " and (author is null or author = " + "'" + Author + "')"
		+ " and (price is null or price = " + Price + "));";		
	*/
	int res = mysql_query(&mysql, sql.c_str());
	if (res == 0)
	{
		MYSQL_RES* result = mysql_store_result(&mysql);
		if (result)
		{
			unsigned long number = (unsigned long)mysql_num_rows(result);
			if (number == 0)/*unfound*/
			{
				mysql_free_result(result);
				set(Type); set(BookName); set(Publisher); set(Author);
				string insertsql = "insert into `books` values("
					+ BookID + "," + Type + "," + BookName + "," 
					+ Publisher + "," + PublishYear + "," + Author + ","
					+ Price + "," + Num + "," + Num + ",now());";
				int error = mysql_query(&mysql, insertsql.c_str());
				if (error)/*information error*/
				{
					printf("insertion fail\n"); 
				}
				else {
					int temp = mysql_query(&mysql, "select * from `books` order by updateTime ASC;");
					if (temp == 0){
						result = mysql_store_result(&mysql);
						output(result);mysql_free_result(result);
					}
				}
			}
			else if (number == 1)/*found existed*/
			{
				mysql_free_result(result);
				string updatesql = "update `books` set totalNum = totalNum + " + Num + " where bookID = " + BookID + ";";
				mysql_query(&mysql, updatesql.c_str());
				updatesql = "update `books` set storageNum = storageNum + " + Num + " where bookID = " + BookID + ";";
				mysql_query(&mysql, updatesql.c_str());
				updatesql = "update `books` set updateTime = now() where bookID = " + BookID + ";";
				mysql_query(&mysql, updatesql.c_str());
				int temp = mysql_query(&mysql, "select * from `books` order by updateTime ASC;");
				if (temp == 0){
					result = mysql_store_result(&mysql);
					output(result); mysql_free_result(result);
				}
			}
		}
	}
}
void BooksIn()
{
	//select all book and show
	int bookres = mysql_query(&mysql, "select * from `books` order by updateTime ASC;");
	if (bookres == 0)/*successful query*/
	{
		MYSQL_RES* bookResult = mysql_store_result(&mysql);
		output(bookResult);
		mysql_free_result(bookResult);
	}
	int bookInMode = 0;
	printf("please input mode\n0:only get 1 book per time\n1:get book from file\n2:delete one kind of book\n");
	cin >> bookInMode;
	if (bookInMode == OneBook)
	{
		printf("input book info(BookID,Type,BookName,Publisher,PublishYear,Author,Price,Num) seperated by space:\n");
		string BookID,Type,BookName, Publisher, PublishYear, Author, Price, Num;
		cin >> BookID >> Type >> BookName >> Publisher >> PublishYear >> Author >> Price >> Num ;
		dealWithOneBookIn(BookID, Type, BookName, Publisher, PublishYear, Author, Price, Num);
	}
	else if (bookInMode == ManyBooks)
	{
		printf("input filepath\n");
		string filepath;  cin >> filepath;
		ifstream input;   input.open(filepath.c_str(), ios::in);
		while (!input.eof())//bug
		{
			string BookID, Type, BookName, Publisher, PublishYear, Author, Price, Num;
			input >> BookID >> Type >> BookName >> Publisher >> PublishYear >> Author >> Price >> Num;
			dealWithOneBookIn(BookID, Type, BookName, Publisher, PublishYear, Author, Price, Num);
		}
		input.close();
		int temp = mysql_query(&mysql, "select * from `books` order by updateTime ASC;");
		if (temp == 0) {
			MYSQL_RES* result = mysql_store_result(&mysql);
			output(result); mysql_free_result(result);
		}
	}
	else if (bookInMode == DeleteOneKind)
	{
		
		printf("input bookid to be deleted:\n");
		string id; cin >> id;
		string checkBookNotReturned;
		/*check all book related to the card are returned or not*/
		checkBookNotReturned = "select * from `records` where (bookID = " + id
			+ ") AND (returnDate is null);";
		int notReturned = mysql_query(&mysql, checkBookNotReturned.c_str());
		if (notReturned == 0)
		{
			MYSQL_RES* temp = mysql_store_result(&mysql);
			if (temp)
			{
				unsigned long number = (unsigned long)mysql_num_rows(temp);
				if (number != 0)
				{
					cout << "not returned book--delete book fails!" << endl;
					return;
				}
			}
			mysql_free_result(temp);
		}


		mysql_query(&mysql, "SET foreign_key_checks = 0; ");
		string sql = "delete from `books` where bookID = " + id + ";";
		int deleteres = mysql_query(&mysql, sql.c_str());
		mysql_query(&mysql, "SET foreign_key_checks = 1; ");
		if (deleteres == 0)
		{
			int temp = mysql_query(&mysql, "select * from `books`;");
			if (temp == 0)
			{
				MYSQL_RES* bookResult = mysql_store_result(&mysql);
				output(bookResult);
				mysql_free_result(bookResult);
			}
		}
		else {
			printf("delete book error\n");
		}
	}
}
void ManageCard()
{
	int res = mysql_query(&mysql, "select * from `cards`;");
	if (res == 0)
	{
		MYSQL_RES* cardResult = mysql_store_result(&mysql);
		output(cardResult);
		mysql_free_result(cardResult);
	}
	int cardMode = 0;
	cout << "please input mode\n0:add new card\n1:delete card" << endl;
	cin >> cardMode;
	if (cardMode == AddCard)
	{
		string sql, cardID, name, department, Type;
		sql = "insert into `cards` values(";
		printf("please input cardID, name, department, Type\n");
		cin >> cardID >> name >> department >> Type;
		set(department); set(name); set(Type);
		sql += cardID + ","+ name + "," + department + ","
			+ Type + ",now());";
		cout << sql << endl;
		int insertres = mysql_query(&mysql, sql.c_str());
		if (insertres == 0)
		{
			int temp = mysql_query(&mysql, "select * from `cards`");
			if (temp == 0)
			{
				MYSQL_RES* cardResult = mysql_store_result(&mysql);
				output(cardResult);
				mysql_free_result(cardResult);
			}
		}
		else {
			printf("insert card error\n");
		}
	}
	else if (cardMode == DeleteCard)
	{
		string sql, cardID, checkBookNotReturned;
		cout << "please input cardID to be deleted" << endl;
		cin >> cardID;
		/*check all book related to the card are returned or not*/
		checkBookNotReturned = "select * from `records` where (cardID = " + cardID
			+ ") AND (returnDate is null);";
		int notReturned = mysql_query(&mysql, checkBookNotReturned.c_str());
		if (notReturned == 0)
		{
			MYSQL_RES* temp = mysql_store_result(&mysql);
			if (temp)
			{
				unsigned long number = (unsigned long)mysql_num_rows(temp);
				if (number != 0)
				{
					cout << "not returned book--delete card fails!" << endl;
					return;
				}
			}
			mysql_free_result(temp);
		}

		string cardExist = "select * from `cards` where cardID = " + cardID + ";";//card exist or not
		int cardExistenceCheck = mysql_query(&mysql, cardExist.c_str());//get card;
		if (cardExistenceCheck == 0)
		{
			MYSQL_RES* temp = mysql_store_result(&mysql);
			if (temp)
			{
				unsigned long number = (unsigned long)mysql_num_rows(temp);
				if (number == 0)
				{
					cout << "card not exist--delete fails!" << endl;
					return;
				}
			}
			mysql_free_result(temp);
		}





		mysql_query(&mysql, "SET foreign_key_checks = 0; ");
		sql = "delete from `cards` where cardID = ";
		sql += cardID + ";";
		int deleteres = mysql_query(&mysql, sql.c_str());
		mysql_query(&mysql, "SET foreign_key_checks = 1; ");// "SET foreign_key_checks = 1; "
		if (deleteres == 0)
		{
			int temp = mysql_query(&mysql, "select * from `cards`;");
			if (temp == 0)
			{
				MYSQL_RES* cardResult = mysql_store_result(&mysql);
				output(cardResult);
				mysql_free_result(cardResult);
			}
		}
		else {
			cout << "delete card error!" << endl;
		}
	}
}
void BorrowBooks(string adminID)
{
	int bookres = mysql_query(&mysql, "select * from `books`;");
	if (bookres == 0)
	{
		MYSQL_RES* bookResult = mysql_store_result(&mysql);
		if(bookResult) output(bookResult);
		mysql_free_result(bookResult);
	}// show books left now
	string bookid,cardid;
	cout << "please input bookID" << endl; cin >> bookid;
	cout << "please input cardID" << endl; cin >> cardid;
	string sql;
	sql = "select * from `cards` where cardID = " + cardid + ";";//card exist or not
	int flag = mysql_query(&mysql, sql.c_str());//get card;
	if (flag == 0)
	{
		MYSQL_RES* temp = mysql_store_result(&mysql);
		if (temp)
		{
			unsigned long number = (unsigned long)mysql_num_rows(temp);
			if (number == 0)
			{
				cout << "card not exist--borrow fails!" << endl;
				return;
			}	
		}
		mysql_free_result(temp);
	}
	sql = "select * from `records` where (cardID = " + cardid + " and returnDate is null);";//not returned books?
	flag = mysql_query(&mysql, sql.c_str());
	if (flag == 0)
	{
		MYSQL_RES* temp = mysql_store_result(&mysql);
		if (temp)
		{
			unsigned long number = (unsigned long)mysql_num_rows(temp);
			if (number != 0)
			{
				cout << "not returned book--borrow fails!" << endl;
				return;
			}
		}
		mysql_free_result(temp);
	}
	string storagenum;
	sql = "select storageNum from `books` where bookID = " + bookid + ";";
	flag = mysql_query(&mysql, sql.c_str());//get storage
	if (flag == 0)
	{
		MYSQL_RES* temp = mysql_store_result(&mysql);
		if (temp)
		{
			unsigned long number = (unsigned long)mysql_num_rows(temp);
			if (number == 0)
				cout << "get storage num fails" << endl;
			else {
				MYSQL_FIELD* fd = mysql_fetch_field(temp);
				while (fd)
					fd = mysql_fetch_field(temp);
				MYSQL_ROW row = mysql_fetch_row(temp);		
					unsigned long* lens = mysql_fetch_lengths(temp);
					storagenum = row[0];
			}
		}
		mysql_free_result(temp);
	}
	if (storagenum == "0")/*no storage more*/
	{
		cout << "error--storage is 0!" << endl; return;
	}
	else {/*bug*/
		string updatesql = "update `books` set storageNum = storageNum - 1 where bookID = " + bookid + ";";
		mysql_query(&mysql, updatesql.c_str());
		//new a record
		int getcardreturn = mysql_query(&mysql, "select * from `records`"),cardnum = 0;
		if (getcardreturn == 0)
		{
			MYSQL_RES* temp = mysql_store_result(&mysql);
			if (temp)	cardnum = (unsigned long)mysql_num_rows(temp);
			mysql_free_result(temp);
			cardnum++;
			string insertsql = "insert into `records` values(" + to_string(cardnum)
				+ "," + cardid + "," + bookid + ",now(),null," + adminID + ");";
			mysql_query(&mysql, insertsql.c_str());
			int show = mysql_query(&mysql, "select * from `records`;");
			if (show == 0)
			{
				temp = mysql_store_result(&mysql);
				if (temp) output(temp);
				mysql_free_result(temp);
			}
		}
	}
}
void ReturnBooks(string adminID)
{
	int bookres = mysql_query(&mysql, "select * from `books`;");
	if (bookres == 0)
	{
		MYSQL_RES* bookResult = mysql_store_result(&mysql);
		if (bookResult) output(bookResult);
		mysql_free_result(bookResult);
	}// show books left now
	string bookid, cardid;
	printf("please input bookID\n"); cin >> bookid;
	printf("please input cardID\n"); cin >> cardid;
	string sql = "select * from `records` where (cardID = "
		+ cardid + " and bookID = " + bookid 
		+ " and returnDate is null);";
	int num = 0;//num of records of borrow
	int flag = mysql_query(&mysql, sql.c_str());//get records of borrow
	if (flag == 0)
	{
		MYSQL_RES* temp = mysql_store_result(&mysql);
		if (temp)
		{
			num = (unsigned long)mysql_num_rows(temp);
			if (num == 0)//no records
			{
				printf("no records exist--fail\n");
				return;
			}
			else {/*records exist*/
				string booksql = "update `books` set storageNum = storageNum + 1 where bookID = " + bookid + ";";
				mysql_query(&mysql, booksql.c_str());
				string recordsql = "update `records` set returnDate = now() where (bookID = " 
					+ bookid + " and cardID = " + cardid + " and returnDate is null);";
				mysql_query(&mysql, recordsql.c_str());
				int show = mysql_query(&mysql, "select * from `records`;");
				if (show == 0)
				{
					MYSQL_RES *showrecords = mysql_store_result(&mysql);
					if (showrecords) output(showrecords);
					mysql_free_result(showrecords);
				}
			}
		}
		mysql_free_result(temp);
	}
}
int main()
{
	MYSQL_RES* result = NULL;//
	mysql_init(&mysql);
	if (!mysql_real_connect(&mysql, host, user, password, database, port, 0, 0))
	{
		cout << "fail" << endl; exit(1);
	}
	else
	{
		cout << "success" << endl;
		mysql_query(&mysql, "SET NAMES GBK");
		int goon = 1;
		while (goon)
		{
			cout << "please input mode" << endl << "0:only check books" << endl << "1:admin login" << endl;
			cin >> mode;
			if (mode == OnlyCheckBooks) {
				OnlyViewBooks();
			}
			else if (mode == AdminLogin) {
				unsigned long number = 0;/*check admin in or not in*/
				string adminID;
				string password;
				cout << "input ID:" << endl; cin >> adminID;
				cout << "input password:" << endl; cin >> password;/*password has no blank*/
				string sql = "select * from `admin` where adminID = " + adminID + " and password = '" + password + "';";
				int adminFind = mysql_query(&mysql, sql.c_str());
				MYSQL_RES* adminResult = mysql_store_result(&mysql);
				if (adminResult) number = (unsigned long)mysql_num_rows(adminResult);
				while (number == 0)
				{
					cout << "no such admin exist\n";
					cout << "input ID:" << endl; cin >> adminID;
					cout << "input password:" << endl; cin >> password;/*password has no blank*/
					sql = "select * from `admin` where adminID = " + adminID + " and password = '" + password + "';";
					adminFind = mysql_query(&mysql, sql.c_str());
					adminResult = mysql_store_result(&mysql);
					if (adminResult) number = (unsigned long)mysql_num_rows(adminResult);
				}
				cout << "admin " + adminID + " successful login!" << endl;	
				int adminPower = 0;
				cout << "input things to do:\n-1:exit login\n0:books In\n1:borrow Books\n2:return Books\n3:card Manage\n";
				cin >> adminPower;
				while (adminPower != exitLogin)
				{
					switch (adminPower)
					{
						case booksIn:
							BooksIn();
							break;
						case borrowBooks:
							BorrowBooks(adminID);
							break;
						case returnBooks:
							ReturnBooks(adminID);
							break;
						case cardManage:
							ManageCard();
							break;
						default:break;
					}
					cout << "input things to do:\n-1:exit login\n0:books In\n1:borrow Books\n2:return Books\n3:card Manage\n";
					cin >> adminPower;
				}
			}
			else {
				cout << "mode error" << endl;
			}
			cout << "Please choose whether to go on or exit:" << endl << "0:exit" << endl << "1:goon" << endl;
			cin >> goon;
		}
	}
	return 0;
}
// https://blog.csdn.net/to_Baidu/article/details/58709499 
// https://blog.csdn.net/baidu_41388533/article/details/127586843
