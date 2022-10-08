package com.oltpbenchmark.benchmarks.chbenchmarkForTrino.chbenchmark;

public class TableNames {

  private static final String suffix = System.getenv("tpcc_name_suffix") == null ? "" : System.getenv("tpcc_name_suffix");


  public static String warehouse(){
    return quote("warehouse" + suffix);
  }

  public static String item(){
    return quote("item" + suffix);
  }

  public static String stock(){
    return quote("stock" + suffix);
  }

  public static String district(){
    return quote("district" + suffix);
  }

  public static String customer(){
    return quote("customer" + suffix);
  }

  public static String history(){
    return quote("history" + suffix);
  }

  public static String oorder(){
    return quote("oorder" + suffix);
  }

  public static String new_order(){
    return quote("new_order" + suffix);
  }

  public static String order_line(){
    return quote("order_line" + suffix);
  }

  public static String region(){
    return quote("region" + suffix);
  }

  public static String nation(){
    return quote("nation" + suffix);
  }

  public static String supplier(){
    return quote("supplier" + suffix);
  }


  private static String quote(String st){
    return "\"" + st + "\"";
  }
}
