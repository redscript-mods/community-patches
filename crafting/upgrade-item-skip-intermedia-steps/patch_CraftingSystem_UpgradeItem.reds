/* switch cases fallthrough, break not supported yet */
public func CalculateCraftingExp(quality: gamedataQuality) -> Int32 {
    switch (quality) {
        case gamedataQuality.Common:
            return TweakDBInterface.GetInt(
                t"Constants.CraftingSystem.commonIngredientXP", 0);
        case gamedataQuality.Uncommon:
            return TweakDBInterface.GetInt(
                t"Constants.CraftingSystem.uncommonIngredientXP", 0);
        case gamedataQuality.Rare:
            return TweakDBInterface.GetInt(
                t"Constants.CraftingSystem.rareIngredientXP", 0);
        case gamedataQuality.Epic:
            return TweakDBInterface.GetInt(
                t"Constants.CraftingSystem.epicIngredientXP", 0);
        case gamedataQuality.Legendary:
            return TweakDBInterface.GetInt(
                t"Constants.CraftingSystem.legendaryIngredientXP", 0);
        default:
            return TweakDBInterface.GetInt(
                t"Constants.CraftingSystem.commonIngredientXP", 0);
    }
}


@replaceMethod(CraftingSystem)
private final func UpgradeItem(owner: wref<GameObject>, itemID: ItemID) {
    let recipeXP: Int32 = 0;
    let randF = RandF();
    let statsSystem = GameInstance.GetStatsSystem(this.GetGameInstance());
    let TS = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let itemData = TS.GetItemData(owner, itemID);
    let statsObjectId = itemData.GetStatsObjectID();
    let materialRetrieveChance = statsSystem.GetStatValue(
        Cast(owner.GetEntityID()),
        gamedataStatType.UpgradingMaterialRetrieveChance);
    let ingredients = this.GetItemFinalUpgradeCost(itemData);
    let i = 0;
    while i < ArraySize(ingredients) {
        if randF >= materialRetrieveChance {
            TS.RemoveItem(owner, ItemID.CreateQuery(ingredients[i].id.GetID()),
                ingredients[i].quantity);
        }
        let ingredientQuality = RPGManager.GetItemQualityFromRecord(
            TweakDBInterface.GetItemRecord(ingredients[i].id.GetID()));
        recipeXP += CalculateCraftingExp(ingredientQuality) * ingredients[i].quantity;
        i += 1;
    }
    let previousItemUpgrade = itemData.GetStatValueByType(gamedataStatType.WasItemUpgraded);
    let itemLevel = itemData.GetStatValueByType(gamedataStatType.ItemLevel) / 10.0;
    let playerPowerLevel = statsSystem.GetStatValue(Cast(owner.GetEntityID()), gamedataStatType.PowerLevel);
    let newItemUpgrade: Float = Cast(previousItemUpgrade + (playerPowerLevel - itemLevel));

    statsSystem.RemoveAllModifiers(statsObjectId, gamedataStatType.WasItemUpgraded, true);
    let mod = RPGManager.CreateStatModifier(
        gamedataStatType.WasItemUpgraded, gameStatModifierType.Additive, newItemUpgrade);
    statsSystem.AddSavedModifier(statsObjectId, mod);
    this.ProcessCraftSkill(recipeXP, statsObjectId);
}
