this.sergeant_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.sergeant";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous nous battons bien, mais nous devons être mieux organisés au cas où les choses tourneraient mal. Je vais nommer un sergent pour vous rallier sur le champ de bataille.";
		this.m.RewardTooltip = "Vous recevrez un accessoire unique qui vous donnera de la détermination supplémentaire.";
		this.m.UIText = "Avoir un homme avec le Talent \"Ralliez les troupes\"";
		this.m.TooltipText = "Ayez au moins un homme avec le Talent \"Ralliez les troupes\". Vous aurez également besoin d\'assez de place dans votre inventaire pour un nouvel objet.";
		this.m.SuccessText = "[img]gfx/ui/events/event_64.png[/img]Au début, vous n\'étiez pas sûr de confier cette tâche importante à %sergeantbrother%, car il était aussi adepte des réjouissances et des fêtes que n\'importe quel autre homme. Mais %sergeantbrother% s\'acquitte de sa tâche avec un zèle d\'abord admirable, puis inquiétant.\n\nL\'aube étant connu comme l\'heure du lever des lâches et des infirmes, %sergeantbrother% décide que tout le monde doit commencer la journée beaucoup plus tôt.\n\nIl fait faire aux hommes les routines habituelles d\'entraînement et leur fait vérifier que leur équipement n\'est pas fendu ou usé, mais à ce travail léger, il ajoute des règles strictes sur l\'établissement et la levée du camp, des exercices de formation, des leçons sur les formations, des marches forcées avec des pierres dans leurs sacs, et un régime de punition détaillé pour quiconque ose prendre du retard. \n\nDes mots tels que \"briseur de dos\", \"cruel\", \"cœur de pierre\" et \"sans pitié\", ainsi que des dizaines d\'épithètes plus salées, résonnent dans l\'air chaque fois que %sergentbrother% est hors de portée de voix, mais jamais quand il dort. Car les frères ont appris que %sergeantbrotherfull% ne dort jamais vraiment.";
		this.m.SuccessButtonText = "Cela nous aidera beaucoup dans les jours à venir.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		this.m.Score = 3 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return false;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops"))
			{
				return true;
			}
		}

		return false;
	}

	function onReward()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local highestBravery = 0;
		local bestSergeant;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops"))
			{
				if (bro.getCurrentProperties().getBravery() > highestBravery)
				{
					bestSergeant = bro;
					highestBravery = bro.getCurrentProperties().getBravery();
				}
			}
		}

		if (bestSergeant != null && bestSergeant.getTitle() == "")
		{
			bestSergeant.setTitle("the Sergeant");
			this.m.SuccessList.push({
				id = 90,
				icon = "ui/icons/special.png",
				text = bestSergeant.getNameOnly() + " est désormais connu sous le nom de " + bestSergeant.getName()
			});
		}

		local item = this.new("scripts/items/accessory/sergeant_badge_item");
		this.World.Assets.getStash().add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local highestBravery = 0;
		local bestSergeant;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops") && bro.getCurrentProperties().getBravery() > highestBravery)
			{
				bestSergeant = bro;
				highestBravery = bro.getCurrentProperties().getBravery();
			}
		}

		_vars.push([
			"sergeantbrother",
			bestSergeant.getNameOnly()
		]);
		_vars.push([
			"sergeantbrotherfull",
			bestSergeant.getName()
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

