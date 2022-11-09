package com.oltpbenchmark.benchmarks.chbenchmarkForSpark.chbenchmark;

public class TableNames {

  private static final String suffix = System.getenv("tpcc_name_suffix") == null ? "" : System.getenv("tpcc_name_suffix");

  private static final String prefix = System.getenv("tpcc_name_prefix") == null ? "" : System.getenv("tpcc_name_prefix");

  private static final Boolean isQuote = System.getenv("tpcc_name_isQuote") == null ? false : Boolean.valueOf(System.getenv("tpcc_name_suffix"));


  public static String warehouse(){
    return quote(prefix + "warehouse" + suffix);
  }

  public static String item(){
    return quote(prefix + "item" + suffix);
  }

  public static String stock(){
    return quote(prefix + "stock" + suffix);
  }

  public static String district(){
    return quote(prefix + "district" + suffix);
  }

  public static String customer(){
    return quote(prefix + "customer" + suffix);
  }

  public static String history(){
    return quote(prefix + "history" + suffix);
  }

  public static String oorder(){
    return quote(prefix + "oorder" + suffix);
  }

  public static String new_order(){
    return quote(prefix + "new_order" + suffix);
  }

  public static String order_line(){
    return quote(prefix + "order_line" + suffix);
  }

  public static String region(){
    return quote(prefix + "region" + suffix);
  }

  public static String nation(){
    return quote(prefix + "nation" + suffix);
  }

  public static String supplier(){
    return quote(prefix + "supplier" + suffix);
  }


  private static String quote(String st){
    if (isQuote){
      return "\"" + st + "\"";
    }else {
      return st;
    }
  }
}
