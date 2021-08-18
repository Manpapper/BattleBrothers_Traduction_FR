this.no_food_variety_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.no_food_variety";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{Vous trouvez les mercenaires autour d\'un feu de camp, sauf qu\'ils n\'ont pas de vraie nourriture à mettre sur les flammes. L\'un d\'eux jette son bol de soupe par terre. C\'est une telle bouillie qu\'elle bouge à peine pour se renverser, ce qui est, honnêtement, assez dégoûtant.%randombrother% vous regarde.%SPEECH_ON%Boss, s\'il vous plaît, laissez-nous trouver de la viande ! Ou quelque chose d\'autre que cette merde!%SPEECH_OFF% Un peu de variété ne ferait pas de mal, vous êtes d\'accord. | %randombrother% vient vous voir et tape une cuillère sur votre bureau. Il y a quelque chose sur la cuillère, mais vous ne pouvez pas dire quoi exactement. Le mercenaire se penche en arrière, les pouces enfoncés dans sa ceinture, la poitrine gonflée par le souffle. Puis il soupire, car il sait qu\'il ne doit pas se comporter de façon aussi déplacée en votre présence. Mais il s\'explique.%SPEECH_ON%Sir, les hommes se plaignent de la nourriture. Je pense que ce serait bon pour le moral de la compagnie si nous allions chercher de la viande et d\'autres produits dans la prochaine ville. Ce n\'est qu\'une suggestion, bien sûr. %SPEECH_OFF%Il part rapidement. Vous ramassez la cuillère et regardez ce qu\'il y a dans la cuillère. Ça... ça ne peut pas vraiment être ce qu\'ils mangent, n\'est-ce pas ? Peut-être qu\'un peu de variété ne ferait pas de mal... | %randombrother% s\'approche avec un bol à la main. Il l\'incline vers l\'avant, montrant le contenu qui est incolore et glisse très lentement sur le bord du bol. Le mercenaire secoue la tête. %SPEECH_ON% Les hommes sont mécontents monsieur, et moi aussi, des dîners que nous avons mangés. Un homme ne peut pas manger le même contenu jour après jour pendant si longtemps, surtout quand il sait qu\'il peut se permettre beaucoup plus. Ce n\'est qu\'une suggestion, monsieur, de ma part et de celle de tous les hommes, que peut-être nous pourrions remplir nos stocks de nourriture pour que chaque repas ne soit pas... eh bien, ceci.%SPEECH_OFF% Il pose le bol et s\'en va. | Quelques-uns de vos mercenaires se plaignent autour d\'un feu de camp. Vous restez à portée de voix, écoutant attentivement car ils pourraient dire des choses qu\'ils ne diraient pas en votre présence. Heureusement, il ne s\'agit pas d\'une mutinerie en cours, mais plutôt d\'une série de critiques sur la cuisine. Il n\'y a tout simplement pas assez de variété dans les stocks de nourriture de la compagnie. Ils sont fatigués de manger la même chose encore et encore. Peut-être pourrait-on remédier à cela dans la prochaine ville que visitera %companyname% ?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, ils n\'auront pas de gâteau.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isLowborn() || bro.getSkills().hasSkill("trait.spartan"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.gluttonous"))
					{
						bro.worsenMood(1.0, "N\'a mangé que des céréales moulues pendant des jours");
					}
					else
					{
						bro.worsenMood(0.5, "N\'a mangé que des céréales moulues pendant des jours");
					}

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 5)
		{
			return;
		}

		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local hasBros = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() || bro.getSkills().hasSkill("trait.spartan"))
			{
				continue;
			}

			hasBros = true;
			break;
		}

		if (!hasBros)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasOtherFood = false;

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() != "supplies.ground_grains")
				{
					hasOtherFood = true;
					break;
				}
			}
		}

		if (hasOtherFood)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

