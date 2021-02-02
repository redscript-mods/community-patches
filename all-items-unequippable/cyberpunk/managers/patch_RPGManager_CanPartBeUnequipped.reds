/*
  all items are unequippable, can be moved to/from inventories
*/
@insert(RPGManager)
public final static func CanPartBeUnequipped(itemID: ItemID) -> Bool {
  return true;
}
