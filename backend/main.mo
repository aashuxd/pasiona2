import Text "mo:core/Text";
import Array "mo:core/Array";
import Runtime "mo:core/Runtime";
import Order "mo:core/Order";
import Principal "mo:core/Principal";
import Iter "mo:core/Iter";
import Map "mo:core/Map";

actor {
  type Inquiry = {
    fullName : Text;
    emailAddress : Text;
    subject : SubjectType;
    message : Text;
    sender : Principal;
  };

  module Inquiry {
    public func compare(inquiry1 : Inquiry, inquiry2 : Inquiry) : Order.Order {
      switch (Text.compare(inquiry1.fullName, inquiry2.fullName)) {
        case (#equal) { Text.compare(inquiry1.emailAddress, inquiry2.emailAddress) };
        case (order) { order };
      };
    };
  };

  type SubjectType = {
    #generalInquiry;
    #bespokeOrder;
    #pressMedia;
    #partnership;
  };

  let inquiriesMap = Map.empty<Principal, Inquiry>();

  public shared ({ caller }) func submitInquiry(fullName : Text, emailAddress : Text, subject : SubjectType, message : Text) : async () {
    if (inquiriesMap.containsKey(caller)) {
      Runtime.trap("This user has already submitted an inquiry.");
    };
    let inquiry : Inquiry = {
      fullName;
      emailAddress;
      subject;
      message;
      sender = caller;
    };
    inquiriesMap.add(caller, inquiry);
  };

  public query func getAllInquiries() : async [Inquiry] {
    inquiriesMap.values().toArray().sort();
  };
};
