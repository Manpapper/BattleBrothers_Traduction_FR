this.broken_cart_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.broken_cart";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_55.png[/img]Alors que vous marchez sur la route, vous trouvez un homme avec un chariot cassé sur le bord du chemin. Près de la charrette, il y a un âne qui se tient à l\'écart et aussi déprimé qu\'un âne puisse paraître. Le marchand a l\'air un peu mieux que ça et votre apparition semble l\'avoir effrayé. Il se recule brièvement.%SPEECH_ON%Vous êtes venu prendre mes affaires ? Si c\'est le cas, vous n\'avez pas besoin de me tuer. Prenez ce que vous voulez.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Messieurs, prenez tout ce que nous pouvons utiliser dans le chariot !",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Laissez-nous vous aider à remettre votre chariot sur la route.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				},
				{
					Text = "On a pas le temps pour ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_55.png[/img]Vous rassurez l\'homme et ordonnez à quelques-uns des meilleurs hommes de %companyname% de remettre le chariot sur la route. Ils s\'en acquittent rapidement, le commerçant semblant plutôt impressionné par leur efficacité. Avec ses marchandises de retour sur la route, il offre quelques gages de gratitude récupérés du chariot lui-même. Ces provisions seront utiles dans les jours à venir.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Au revoir.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveStuff(1);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_55.png[/img]Le marchand est effrayé de votre présence, mais vous le libérez rapidement de ses craintes. Quelques hommes reçoivent l\'ordre de remettre le chariot sur le chemin. Ils le font aussi vite que des hommes robustes le peuvent, mais quand c\'est fini, l\'un d\'eux crie et se met à plat ventre.\n\nLe commerçant, les yeux écarquillés par une nouvelle horreur, vous offre rapidement quelques provisions en gage de sa gratitude. Peut-être qu\'il pense que vous allez le punir pour les blessures ? Quoi qu\'il en soit, les fournitures seront les bienvenues pour les jours à venir.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère que ça en valait le coup.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Injured.getImagePath());
				local injury = _event.m.Injured.addInjury(this.Const.Injury.Helping);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " souffre de " + injury.getNameOnly()
					}
				];
				this.List.extend(_event.giveStuff(1));
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_55.png[/img]Vous ordonnez aux hommes de fouiller le chariot et de prendre ce qu\'ils peuvent. %randombrother% tire son épée et semble prêt à tuer l\'âne, l\'animal regardant stupidement sa propre mort dans le reflet de la lame. Le marchand crie et vous tendez la main pour suspendre l\'exécution.%SPEECH_ON%Laissez l\'animal de trait là où il se trouve.%SPEECH_OFF%Le commerçant offre de maigres remerciements tandis que vos hommes marche derrière lui, ses marchandises dans leurs mains.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rangez tout, on avance.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveStuff(3);
			}

		});
	}

	function giveStuff( _mult )
	{
		local result = [];
		local gaveSomething = false;

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local food = this.new("scripts/items/supplies/bread_item");
			this.World.Assets.getStash().add(food);
			result.push({
				id = 10,
				icon = "ui/items/" + food.getIcon(),
				text = "Vous recevez " + food.getName()
			});
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local amount = this.Math.rand(1, 10) * _mult;
			this.World.Assets.addArmorParts(amount);
			result.push({
				id = 10,
				icon = "ui/icons/asset_supplies.png",
				text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] d\'Outils et de Provisions."
			});
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local amount = this.Math.rand(1, 5) * _mult;
			this.World.Assets.addMedicine(amount);
			result.push({
				id = 10,
				icon = "ui/icons/asset_medicine.png",
				text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] de Provisions Médicales."
			});
		}

		if (!gaveSomething)
		{
			local food = this.new("scripts/items/supplies/bread_item");
			this.World.Assets.getStash().add(food);
			result.push({
				id = 10,
				icon = "ui/items/" + food.getIcon(),
				text = "Vous recevez " + food.getName()
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( b in brothers )
		{
			if (!b.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(b);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 9;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Injured = null;
	}

});

