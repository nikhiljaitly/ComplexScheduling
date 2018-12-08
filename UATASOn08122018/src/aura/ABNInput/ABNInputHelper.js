({ 
    execute : function(action) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response);
                }else if (state === "ERROR") {
                    reject(response);
                }
            });
            $A.enqueueAction(action);
        });
    },
    searchABNChange : function(component, abn) {
        var _self= this;
        var abnAction = component.get("c.searchABN");
        
        var abnLength = abn.length;
        var nomilisedABN = abn.replace(/\s/g,'');
        console.log("ABN Results" ,_self.validateABN(nomilisedABN));
        if(_self.validateABN(nomilisedABN).valid) {
            abnAction.setParams({"abn": nomilisedABN});
            // Send web service to retrieve the data 
            this.execute(abnAction).then(function(response) {
                console.log("response", response);
                var abnObj = JSON.parse(response.getReturnValue());
                if(!abnObj.Message) {
                    var fieldInfoEvent = component.getEvent ("fieldInfo");
                    fieldInfoEvent.setParams({"type": "ABN", "payload": response.getReturnValue()});
                    fieldInfoEvent.fire();    
                } else {
                    component.set(
                        "v.errors", _self.addErrorMessage(
                            abnObj.Message));  
                }                
            });
        } else {
            component.set(
                "v.errors", _self.addErrorMessage(
                    "Enter a valid ABN Number"));
        }
    },
    addErrorMessage: function(message) {
        var messages = [];
        messages.push({"message": message});
        return messages;
    },
    addWeighted: function (p, v, i) {
        var acnWeights = [8, 7, 6, 5, 4, 3, 2, 1];
        var weights = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
        return p+v*weights[i];
    },
    
    // http://downloads.icbglobal.org/au/ATO/ATO_Format_of_the_ABN_NAT2956.pdf
    generateABNfromACN: function (acn) {
        var digits = acn.replace(/[^\d]/g, '').split('').map(Number);
        var sum = [0, 0].concat(digits).reduce(this.addWeighted, 0);
        var moduloAdd = 89 - sum%89;
        var a10 = moduloAdd%10;
        var a11 = 1 + (moduloAdd - a10)/10;
        return [a11, a10].concat(digits).join('');
    },
    
    // also ARBN and ARSN
    validateACN: function (acn) {
        var digits = acn.replace(/[^\d]/g, '').split('').map(Number);
        console.log(digits);
        if (digits.length != 9)
            return { valid: false };
        
        var sum = digits.slice(0,8).reduce(this.addWeighted, 0);
        console.log('ACN:', sum);
        var lastDigit = 10 - sum%10;
        if (lastDigit === digits[8])
            return { valid: true };
        
        return {
            valid: false,
            suggestion: digits.slice(0,8).concat([lastDigit]).join('')
        }
    },
    validateABN: function  (abn) {
        var weights = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
        var suggestLookup = [];
        for (var i=0; i < 10; ++i) {
            suggestLookup[i*19 % 89] = i;
        }
        var digits = abn.replace(/[^\d]/g, '').split('').map(Number);
        if (digits.length != 11)
            return { valid: false };
        
        digits[0] -= 1;
        
        var sum = digits.reduce(this.addWeighted, 0);
        
        if (sum % 89 == 0) {
            return {
                valid: true,
                isACN: this.validateACN(digits.slice(-9).join('')).valid
            };
        }
        
        digits[0] += 1;
        
        var sum1 = sum - digits[10]*weights[10];
        var digit = suggestLookup[89 - sum1%89];
        if (typeof digit != 'undefined') {
            return {
                valid: false,
                suggestion: digits.slice(0,10).concat([digit]).join('')
            }
        } else {
            var sum2 = sum1 - digits[9]*weights[9];
            for(var i=0; i<10; ++i) {
                sum1 = sum2 + i*weights[9];
                digit = suggestLookup[89 - sum1%89];
                if (typeof digit != 'undefined') {
                    return {
                        valid: false,
                        suggestion: digits.slice(0,9).concat([i, digit]).join('')
                    }
                }
            }
        }
    }
})