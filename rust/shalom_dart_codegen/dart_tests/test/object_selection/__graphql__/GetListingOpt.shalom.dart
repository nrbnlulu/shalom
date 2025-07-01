














// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';




typedef JsonObject = Map<String, dynamic>;




class GetListingOptResponse{

    /// class members
    
        
            final GetListingOpt_listingOpt? listingOpt;   
        
    
    // keywordargs constructor
    GetListingOptResponse({
    
        this.listingOpt,
    
    });
    static GetListingOptResponse fromJson(JsonObject data) {
    
        
            final GetListingOpt_listingOpt? listingOpt_value;
            
                final JsonObject? listingOpt$raw = data['listingOpt']; 
                if (listingOpt$raw != null) {
                    listingOpt_value = GetListingOpt_listingOpt.fromJson(listingOpt$raw);
                } else {
                    listingOpt_value = null;
                }
            
        
    
    return GetListingOptResponse(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    GetListingOptResponse updateWithJson(JsonObject data) {
    
        
        final GetListingOpt_listingOpt? listingOpt_value;
        if (data.containsKey('listingOpt')) {
            
                final JsonObject? listingOpt$raw = data['listingOpt'];
                if (listingOpt$raw != null) {
                    listingOpt_value = GetListingOpt_listingOpt.fromJson(listingOpt$raw);
                } else {
                    listingOpt_value = null;
                }
            
        } else {
            listingOpt_value = listingOpt;
        }

    
    
    return GetListingOptResponse(
    
        
        listingOpt: listingOpt_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOptResponse &&
    
        other.listingOpt == listingOpt 
    
    );
    }
    @override
    int get hashCode =>
    
        listingOpt.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'listingOpt':
            
                listingOpt?.toJson()
            
        ,
    
    };
    }

}


// ------------ OBJECT DEFINITIONS -------------


    class GetListingOpt_listingOpt  {
        
    /// class members
    
        
            final String id;
        
    
        
            final String name;
        
    
        
            final int? price;
        
    
    // keywordargs constructor
    GetListingOpt_listingOpt({
    required
        this.id,
    required
        this.name,
    
        this.price,
    
    });
    static GetListingOpt_listingOpt fromJson(JsonObject data) {
    
        
            final String id_value;
            
                id_value = data['id'];
            

        
    
        
            final String name_value;
            
                name_value = data['name'];
            

        
    
        
            final int? price_value;
            
                price_value = data['price'];
            

        
    
    return GetListingOpt_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    GetListingOpt_listingOpt updateWithJson(JsonObject data) {
    
        
    final String id_value;
    if (data.containsKey('id')) {
        
            id_value = data['id'];
        
    } else {
        id_value = id;
    }

        
    
        
    final String name_value;
    if (data.containsKey('name')) {
        
            name_value = data['name'];
        
    } else {
        name_value = name;
    }

        
    
        
    final int? price_value;
    if (data.containsKey('price')) {
        
            price_value = data['price'];
        
    } else {
        price_value = price;
    }

        
    
    return GetListingOpt_listingOpt(
    
        
        id: id_value,
    
        
        name: name_value,
    
        
        price: price_value,
    
    );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetListingOpt_listingOpt &&
    
        other.id == id &&
    
        other.name == name &&
    
        other.price == price 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            id,
        
            
            name,
        
            
            price,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'id':
            
                
                    id
                
            
        ,
    
        
        'name':
            
                
                    name
                
            
        ,
    
        
        'price':
            
                
                    price
                
            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetListingOpt extends Requestable {
    

    RequestGetListingOpt(
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  {}  ;
        return Request(
            query: r"""query GetListingOpt {
  listingOpt {
    id
    name
    price
  }
}""", 
            variables: variablesJson, 
            opType: OperationType.Query, 
            StringopName: 'GetListingOpt'
        );
    }
}



// ------------ Node DEFINITIONS -------------

class GetListingOptNode extends Node {
  GetListingOptResponse? _obj;
  GetListingOptNode({required super.id});

  @override 
  void updateStoreWithRaw(JsonObject raw, NodeManager manager) {
    _obj = GetListingOptResponse.fromJson(raw);
    manager.addOrUpdateNode(this);
  }

  @override
  void updateWithJson(JsonObject newData) {
    if (_obj != null) {
        _obj = _obj?.updateWithJson(newData);
    } else {
        _obj = GetListingOptResponse.fromJson(newData);
    }
    notifyListeners();
  }

  @override
  void setObj(JsonObject? data) {
     if (data != null) {
        _obj = GetListingOptResponse.fromJson(data);
     }
  }
  
  @override
  JsonObject? data() {
    final data = _obj?.toJson();
    return data;
  }

  GetListingOptResponse? get obj {
    return _obj;
  }
} 
// ------------ END Node DEFINITIONS -------------