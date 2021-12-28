this.kings_guard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.kings_guard";
		this.m.Name = "King\'s Guard";
		this.m.Icon = "ui/backgrounds/background_59.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "You thought %name% a simple peasant when you found him freezing in the wastes of the north. As it turned out, he was very much a King\'s Guard, not only in title but in action. He fought like a man protecting his liege from the world at large. Thankfully, for a time, that \'liege\' happened to be you. Last you heard he traveled to the southern realms and is protecting an upstart nomad king trying to overthrow the local Viziers.";
		this.m.BadEnding = "You never truly found out which king %name% supposedly \'guarded\' in his days before joining the %companyname%, but it matters not now. After your abrupt retirement, the King\'s Guard took himself to the southern deserts. He served a Vizier for a time but failed to protect the royal from a concubine\'s poison. For punishment, %name%\'s equipment was melted into a pot and poured down his throat.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 30;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
		actor.setTitle("the Kingsguard");
	}

});

