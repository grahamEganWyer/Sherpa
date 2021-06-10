require 'pg'

def run_sql(sql)
    db = PG.connect(dbname: 'sherpa')
    res = db.exec(sql)
    db.close
    return res
end