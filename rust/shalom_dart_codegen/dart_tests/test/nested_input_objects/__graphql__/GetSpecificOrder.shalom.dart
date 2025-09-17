






















// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, camel_case_types, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages

import "schema.shalom.dart";


import 'package:shalom_core/shalom_core.dart';
import 'package:collection/collection.dart';




typedef JsonObject = Map<String, dynamic>;




class GetSpecificOrderResponse{

    
    /// class members
    
        final GetSpecificOrder_getSpecificOrder? getSpecificOrder;
    
    // keywordargs constructor
    GetSpecificOrderResponse({
    
        this.getSpecificOrder,
    
    });

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final getSpecificOrderNormalized$Key = "getSpecificOrder";
            final getSpecificOrder$cached = this$NormalizedRecord[getSpecificOrderNormalized$Key];
            final getSpecificOrder$raw = data["getSpecificOrder"];
            if (getSpecificOrder$raw != null){
                
                    GetSpecificOrder_getSpecificOrder.updateCachePrivate(
                        getSpecificOrder$raw as JsonObject,
                        ctx,
                        this$fieldName: getSpecificOrderNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("getSpecificOrder") && getSpecificOrder$cached != null){
                    this$NormalizedRecord[getSpecificOrderNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetSpecificOrderResponse fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final getSpecificOrder$raw = data["getSpecificOrder"];
            final GetSpecificOrder_getSpecificOrder? getSpecificOrder$value = 
    
        
            getSpecificOrder$raw == null ? null :
        
    
;
        return GetSpecificOrderResponse(
            getSpecificOrder: getSpecificOrder$value,
            
        );
    }
    static GetSpecificOrderResponse fromJson(JsonObject data, {ShalomCtx? ctx}){
            // if ctx not provider we create dummy one
            ctx ??= ShalomCtx.withCapacity();
            // first update the cache
            final CacheUpdateContext updateCtx = CacheUpdateContext(shalomContext: ctx!);
            // TODO: handle arguments
            updateCachePrivate(
                data,
                updateCtx,
                this$fieldName: "getSpecificOrder",
                this$data: getOrCreateObject(updateCtx.getOrCreateCachedObjectRecord("ROOT_QUERY"), "getSpecificOrder")
            );
            return fromJsonImpl(data, ctx);
        }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetSpecificOrderResponse &&
    
        
    
        other.getSpecificOrder == getSpecificOrder
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getSpecificOrder.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getSpecificOrder':
            
                
    
        
            this.getSpecificOrder?.toJson()
        
    

            
        ,
    
    };
    }

}

// ------------ OBJECT DEFINITIONS -------------


    class GetSpecificOrder  {
        
    
    /// class members
    
        final GetSpecificOrder_getSpecificOrder? getSpecificOrder;
    
    // keywordargs constructor
    GetSpecificOrder({
    
        this.getSpecificOrder,
    
    });

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final getSpecificOrderNormalized$Key = "getSpecificOrder";
            final getSpecificOrder$cached = this$NormalizedRecord[getSpecificOrderNormalized$Key];
            final getSpecificOrder$raw = data["getSpecificOrder"];
            if (getSpecificOrder$raw != null){
                
                    GetSpecificOrder_getSpecificOrder.updateCachePrivate(
                        getSpecificOrder$raw as JsonObject,
                        ctx,
                        this$fieldName: getSpecificOrderNormalized$Key,
                        this$data: this$NormalizedRecord
                    );

                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("getSpecificOrder") && getSpecificOrder$cached != null){
                    this$NormalizedRecord[getSpecificOrderNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetSpecificOrder fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final getSpecificOrder$raw = data["getSpecificOrder"];
            final GetSpecificOrder_getSpecificOrder? getSpecificOrder$value = 
    
        
            getSpecificOrder$raw == null ? null :
        
    
;
        return GetSpecificOrder(
            getSpecificOrder: getSpecificOrder$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetSpecificOrder &&
    
        
    
        other.getSpecificOrder == getSpecificOrder
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        getSpecificOrder.hashCode;
    
    JsonObject toJson() {
    return {
    
        
        'getSpecificOrder':
            
                
    
        
            this.getSpecificOrder?.toJson()
        
    

            
        ,
    
    };
    }

    }

    class GetSpecificOrder_getSpecificOrder  {
        
    
    /// class members
    
        final int? quantity;
    
        final double? price;
    
        final String? name;
    
    // keywordargs constructor
    GetSpecificOrder_getSpecificOrder({
    
        this.quantity,
    
        this.price,
    
        this.name,
    
    });

    static void updateCachePrivate(JsonObject data,
            CacheUpdateContext ctx,
            {
            /// can be just the selection name but also may include serialized arguments.
            required RecordID  this$fieldName,
            required JsonObject this$data
            }){
        String this$normalizedID;
        JsonObject this$NormalizedRecord;
        
            this$normalizedID = this$fieldName;
            this$NormalizedRecord = getOrCreateObject(this$data, this$fieldName);
        // TODO: handle arguments
            final quantityNormalized$Key = "quantity";
            final quantity$cached = this$NormalizedRecord[quantityNormalized$Key];
            final quantity$raw = data["quantity"];
            if (quantity$raw != null){
                
                    if (quantity$cached != quantity$raw){
                        
                    }
                    this$NormalizedRecord[quantityNormalized$Key] = quantity$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("quantity") && quantity$cached != null){
                    this$NormalizedRecord[quantityNormalized$Key] = null;
                    
                }
            }

        // TODO: handle arguments
            final priceNormalized$Key = "price";
            final price$cached = this$NormalizedRecord[priceNormalized$Key];
            final price$raw = data["price"];
            if (price$raw != null){
                
                    if (price$cached != price$raw){
                        
                    }
                    this$NormalizedRecord[priceNormalized$Key] = price$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("price") && price$cached != null){
                    this$NormalizedRecord[priceNormalized$Key] = null;
                    
                }
            }

        // TODO: handle arguments
            final nameNormalized$Key = "name";
            final name$cached = this$NormalizedRecord[nameNormalized$Key];
            final name$raw = data["name"];
            if (name$raw != null){
                
                    if (name$cached != name$raw){
                        
                    }
                    this$NormalizedRecord[nameNormalized$Key] = name$raw;
                
            } else {
                // if this field was null in the response and key exists clear the cache.
                if (data.containsKey("name") && name$cached != null){
                    this$NormalizedRecord[nameNormalized$Key] = null;
                    
                }
            }

        
    }

    static GetSpecificOrder_getSpecificOrder fromJsonImpl(JsonObject data, ShalomCtx ctx) {
        
            final quantity$raw = data["quantity"];
            final int? quantity$value = 
    
        
            
                quantity$raw as int?
            
        
    
;
        
            final price$raw = data["price"];
            final double? price$value = 
    
        
            
                price$raw as double?
            
        
    
;
        
            final name$raw = data["name"];
            final String? name$value = 
    
        
            
                name$raw as String?
            
        
    
;
        return GetSpecificOrder_getSpecificOrder(
            quantity: quantity$value,
            price: price$value,
            name: name$value,
            
        );
    }
    @override
    bool operator ==(Object other) {
    return identical(this, other) ||
    (other is GetSpecificOrder_getSpecificOrder &&
    
        
    
        other.quantity == quantity
    
 &&
    
        
    
        other.price == price
    
 &&
    
        
    
        other.name == name
    
 
    
    );
    }
    @override
    int get hashCode =>
    
        Object.hashAll([
        
            
            quantity,
        
            
            price,
        
            
            name,
        
        ]);
    
    JsonObject toJson() {
    return {
    
        
        'quantity':
            
                
    
        
            this.quantity
        
    

            
        ,
    
        
        'price':
            
                
    
        
            this.price
        
    

            
        ,
    
        
        'name':
            
                
    
        
            this.name
        
    

            
        ,
    
    };
    }

    }


// ------------ END OBJECT DEFINITIONS -------------


class RequestGetSpecificOrder extends Requestable {
    
    final GetSpecificOrderVariables variables;
    

    RequestGetSpecificOrder(
        
        {
            required this.variables,
        }
        
    );

    @override
    Request toRequest() {
        JsonObject variablesJson =  variables.toJson() ;
        return Request(
            query: r"""query GetSpecificOrder($id: ID!, $specificOrder: SpecificOrder!) {
  getSpecificOrder(id: $id, specificOrder: $specificOrder) {
    quantity
    price
    name
  }
}""",
            variables: variablesJson,
            opType: OperationType.Query,
            opName: 'GetSpecificOrder'
        );
    }
}


class GetSpecificOrderVariables {
    
    
        final String id;
    
        final SpecificOrder specificOrder;
    

    GetSpecificOrderVariables (
        
            {
            

    
        
            required this.id
        ,
    
    
    
        
            required this.specificOrder
        ,
    
    

            }
        
    );

    JsonObject toJson() {
        JsonObject data = {};
        

    
    
        data["id"] = 
    
        this.id
    
;
    

    
    
        data["specificOrder"] = 
    
        
            this.specificOrder.toJson()
        
    
;
    


        return data;
    }

    
GetSpecificOrderVariables updateWith(
    {
        
            
                String? id
            
            ,
        
            
                SpecificOrder? specificOrder
            
            
        
    }
) {
    
        final String id$next;
        
            if (id != null) {
                id$next = id;
            } else {
                id$next = this.id;
            }
        
    
        final SpecificOrder specificOrder$next;
        
            if (specificOrder != null) {
                specificOrder$next = specificOrder;
            } else {
                specificOrder$next = this.specificOrder;
            }
        
    
    return GetSpecificOrderVariables(
        
            id: id$next
            ,
        
            specificOrder: specificOrder$next
            
        
    );
}


}
