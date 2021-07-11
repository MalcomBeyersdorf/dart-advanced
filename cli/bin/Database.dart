import 'dart:io';
import 'package:sqljockey5/constants.dart';
import 'package:sqljockey5/sqljockey5.dart';
import 'package:sqljockey5/utils.dart';

main(List<String> arguments) async {
    var pool = ConnectionPool{
        host: 'localhost',
        port: 3306,
        user: 'malcom',
        password: 'asd123',
        db: 'school',
        max: 5
    };
    var result = await pool.query('Select & from teachers');
    print('Results $result.lenght');
    pool.closeConnectionsNow();

    // Insert names examples
    var query = await pool.prepare('insert into teachers (name, topic) values (?,?)');
    await insert(query, 'bob', 'science');

    //
    var results = await pool.query('select Name, Topic from teachers');
    await results.forEach((row) {
        print('Name: $row.Name');
    });
    pool.closeConnectionsNow();

    // Transaction
    var trans = await pool.startTransaction();
    try {
        int id = await inset(pool, 'Zazzy', 'Dart');
        int person = await find(pool, 'Brayn');
        await delete(pool, person);

        await trans.commit();
        print('Done!');
    } catch (e) {
        print(e.toString());
        await trans.rollback();
    }
    finally {
        await pool.closeConnectionsNow();
        exit(0);
    }

}

Future<int> find(var pool, String name) async {
    Query query = await pool.prepare('Select idteachers from teachers where Name=?');
    Results results = await query.execute([name]);
    Row row = await results.first;
    return row[0];
}

Future<int> inset(var pool, String name, String topic) async {
    Query query = await pool.prepare('insert into teachers (name, topic) values(?, ?)');
    Results results = await query.execute([name, topic]);
    return results.insertId;
}

Future delete(var pool, int value) async {
    Query query = await pool.prepare('delete from teachers where idteachers=?');
    Results results = await query.execute([value]);
}

void insert(var query, String name, String topic) async {
    var result = await query.execute([name, topic]);
    print('New user created id: $result.insertId');
}
