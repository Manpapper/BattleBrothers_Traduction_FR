this.kings_guard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.kings_guard";
		this.m.Name = "Guarde du Roi";
		this.m.Icon = "ui/backgrounds/background_59.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "Vous pensiez que %name% était un simple paysan quand vous l\'avez trouvé gelé dans les plaines du nord. Il s\'est avéré qu\'il était bien un Garde du Roi, non seulement via son titre mais aussi sur le terrain. Il s\'est battu comme un homme protégeant son seigneur contre le monde qui l\'entoure. Heureusement, pendant un temps, ce \"mensonge\" s\'est avéré être vous. Aux dernières nouvelles, il a voyagé dans les royaumes du sud et protège un roi nomade arriviste qui tente de renverser les Vizirs locaux.";
		this.m.BadEnding = "En son temps, vous n\'avez jamais vraiment su quel roi %name% avait soi-disant \"gardé\" avant de rejoindre la compagnie %companyname%, mais ça n\'a pas d\'importance maintenant. Après votre retraite abrupte, le garde du roi s\'est rendu dans les déserts du sud. Un vizir à été empoisonné par sa concubine, malheureusement et en tant que garde, il n\'a pas réussi à le protéger. Pour le punir, tout l\'équipement de %name% a été fondu dans un pot et versé dans sa gorge.";
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

