/*
  when selling junk, also sell all edibles (food, drinks, alcohol)
*/
@replaceMethod(FullscreenVendorGameController)
private final func GetSellableJunk() -> array<wref<gameItemData>> {
    let i = 0;
    let result: array<wref<gameItemData>>;
    let sellableItems = this.m_VendorDataManager.GetItemsPlayerCanSell();

    while i < ArraySize(sellableItems) {
        let type = RPGManager.GetItemType(sellableItems[i].GetID());
        if Equals(type, gamedataItemType.Gen_Junk) || Equals(type, gamedataItemType.Con_Edible) {
            let tmp: wref<gameItemData> = sellableItems[i]; /* needs conversion to wref */
            ArrayPush(result, tmp);
        }
        i += 1;
    }

    return result;
}
