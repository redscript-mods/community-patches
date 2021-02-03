/* multiply all crafting XP by 100 */

@replaceMethod(CraftingSystem)
private final func ProcessCraftSkill(xpAmount: Int32, craftedItem: StatsObjectID) {
  let xpEvent = new ExperiencePointsEvent();
  xpEvent.amount = xpAmount * 100;
  xpEvent.type = gamedataProficiencyType.Crafting;
  GetPlayer(this.GetGameInstance()).QueueEvent(xpEvent);
}
