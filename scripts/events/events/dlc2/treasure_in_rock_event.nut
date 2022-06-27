this.treasure_in_rock_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null,
		Tiny = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.treasure_in_rock";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_66.png[/img]%randombrother% vous amène à une fissure sur le côté d\'une berme de caliche. Vous pouvez voir quelque chose qui brille dans l\'obscurité. Quoi qu\'il en soit, il serait difficile de creuser cette roche sédimentaire. Le mercenaire acquiesce.%SPEECH_ON%Je sais que c\'est là-dedans,  je pense que ça vaut le coup d\'aller le chercher. Qu\'en pensez-vous?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Creusons!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "DigGood";
						}
						else
						{
							return "DigBad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Miner != null)
				{
					this.Options.push({
						Text = "L\'expertise d\'un mineur pourrait être utile ici.",
						function getResult( _event )
						{
							return "Miner";
						}

					});
				}

				if (_event.m.Tiny != null)
				{
					this.Options.push({
						Text = "L\'un d'entre vous est assez petit pour entrer dans ce trou.?",
						function getResult( _event )
						{
							return "Tiny";
						}

					});
				}

				this.Options.push({
					Text = "Ce n\'est pas ce que nous recherchons. Préparez-vous à passer à autre chose.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Miner",
			Text = "[img]gfx/ui/events/event_66.png[/img]Le %miner% hoche la tête à votre demande. Il rassemble ses outils et examine la berme pendant quelques minutes. Il crache sur la roche, hoche la tête et se met au travail. Quelques minutes plus tard, il est déjà en train de désherber certains coins et de réduire la terre dure en poussière. Le trésor caché se révèle, l\'homme le libère et le donne.%SPEECH_ON%Un bon entraînement, capitaine, et je dirais que ça en valait la peine. J\'apprécie que vous comptiez sur moi, je le pense honnêtement.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Beau travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				local item = this.new("scripts/items/trade/uncut_gems_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/trade/uncut_gems_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				_event.m.Miner.improveMood(2.0, "Used his mining experience to benefit the company");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Tiny",
			Text = "[img]gfx/ui/events/event_66.png[/img]Le tout petit %tiny% s\'approche de la fissure dans la berme et la regarde fixement. Il tourne en rond comme une toupie.%SPEECH_ON%Je n\'ai pas l\'habitude de faire des suppositions, mais j\'ai l\'impression d\'avoir été offensé.%SPEECH_OFF%Vous lui assurez que vous ne pensez pas du tout à mal en lui demandant d\'utiliser sa petite taille amusante. Il acquiesce et s\'attelle à la tâche comme s\'il était né pour ça, se faufilant facilement dans la fissure jusqu\'à ce qu\'il n\'y ait plus qu\'une paire de bottes qui dépassent de la terre. L\'un des mercenaires jette un coup d\'œil et demande tranquillement si c\'est bizarre qu\'il ressente l\'envie de chatouiller des pieds. Vous demandez ce que ça veut dire sans avoir l\'intention d\'obtenir une réponse. Heureusement, %tiny% crie qu\'il a l\'objet et les hommes l\'aident à sortir. %tiny% se retourne avec le trésor qu\'il brandi en l\'air avec ses petites mains.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Beau travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tiny.getImagePath());
				local item = this.new("scripts/items/armor/ancient/ancient_breastplate");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez an " + item.getName()
				});
				item = this.new("scripts/items/weapons/ancient/ancient_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez an " + item.getName()
				});
				_event.m.Tiny.improveMood(2.0, "Used his unique stature to benefit the company");

				if (_event.m.Tiny.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tiny.getMoodState()],
						text = _event.m.Tiny.getName() + this.Const.MoodStateEvent[_event.m.Tiny.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "DigGood",
			Text = "[img]gfx/ui/events/event_66.png[/img]Vous ordonnez aux mercenaires d\'utiliser tous les outils disponibles pour creuser dans la berme. Cela prend un bon moment pour avancer dans la caliche, mais finalement %randombrother% parvient à ameublir la terre suffisamment pour atteindre l\'intérieur et sortir le trésor caché. Il s\'agit d\'un calice en or et d\'un certain nombre d\'autres objets que l\'on pourrait vendre sur le marché.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La chance nous sourit aujourd'hui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Tools and Supplies."
				});
				local item = this.new("scripts/items/loot/golden_chalice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "DigBad",
			Text = "[img]gfx/ui/events/event_66.png[/img]Vous ordonnez à quelques mercenaires de s\'attaquer à la berme avec les outils adéquats. Ils s\'y mettent du mieux qu\'ils peuvent, mais ils ont à peine commencé à creuser qu\'un morceau de caliche se détache et frappe %hurtbro%, l\'assommant sur le coup. Le trésor recherché roule à côté de lui et vous découvrez qu\'il s\'agit d\'un morceau de métal rouillé qui ne sert pratiquement à rien.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Putain de merde.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local amount = this.Math.rand(5, 10);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Tools and Supplies."
				});
				local injury = _event.m.Other.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " souffre de " + injury.getNameOnly()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Steppe && currentTile.TacticalType != this.Const.World.TerrainTacticalType.SteppeHills)
		{
			return;
		}

		if (this.World.Assets.getArmorParts() < 20)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_miner = [];
		local candidates_tiny = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.miner")
			{
				candidates_miner.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.tiny"))
			{
				candidates_tiny.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.lucky") && !bro.getSkills().hasSkill("trait.swift"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_miner.len() != 0)
		{
			this.m.Miner = candidates_miner[this.Math.rand(0, candidates_miner.len() - 1)];
		}

		if (candidates_tiny.len() != 0)
		{
			this.m.Tiny = candidates_tiny[this.Math.rand(0, candidates_tiny.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner != null ? this.m.Miner.getNameOnly() : ""
		]);
		_vars.push([
			"tiny",
			this.m.Tiny != null ? this.m.Tiny.getNameOnly() : ""
		]);
		_vars.push([
			"hurtbro",
			this.m.Other.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Miner = null;
		this.m.Tiny = null;
		this.m.Other = null;
	}

});

