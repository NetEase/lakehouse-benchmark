package com.oltpbenchmark.types;

public class TransactionStatusAndIsCommit {
  TransactionStatus transactionStatus;
  Boolean isCommit;

  public TransactionStatusAndIsCommit(TransactionStatus transactionStatus, Boolean isCommit) {
    this.transactionStatus = transactionStatus;
    this.isCommit = isCommit;
  }

  public TransactionStatusAndIsCommit(TransactionStatus transactionStatus) {
    this.transactionStatus = transactionStatus;
  }

  public TransactionStatus getTransactionStatus() {
    return this.transactionStatus;
  }

  public Boolean getIsCommit() {
    return this.isCommit == null ? true : isCommit;
  }
}
