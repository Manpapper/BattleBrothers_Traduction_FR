this.shooting_contest_event <- this.inherit("scripts/events/event", {
	m = {
		Archer1 = null,
		Archer2 = null
	},
	function create()
	{
		this.m.ID = "event.shooting_contest";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] Un murmure se fait de plus en plus fort jusqu\'à ce que vous ne puissiez plus vous concentrer. Vous posez votre plume d\'oie avec l\'énergie que la bouteille d\'encre peut supporter sans se briser et sortez de votre tente. %archer1% et %archer2% sont là à se chamailler pour savoir qui est le meilleur tireur. En vous voyant, ils ne perdent pas de temps pour demander s\'ils peuvent organiser un concours de tir pour décider qui a raison.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, très bien.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "On ne peut pas se permettre de gaspiller les flèches.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_10.png[/img] Vous levez les mains et dites aux hommes de faire ce qu\'ils doivent faire avant de vous retirer dans votre tente. Dehors, vous entendez le bruit des flèches lâchées, rapidement suivi par le bruit sourd des flèches qui atteignent leur cible. Encore et encore. Le vacarme des hommes s\'amplifie tandis que ce que vous ne pouvez que supposer être une foule d\'observateurs grandissante. Finalement, le concours touche à sa fin - ce qui est indiqué par un silence rafraîchissant - et vous vous remettez au travail.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Enfin la paix et le calme.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.getFlags().increment("ParticipatedInShootingContests", 1);
				_event.m.Archer2.getFlags().increment("ParticipatedInShootingContests", 1);
				this.World.Assets.addAmmo(-30);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-30[/color] Munitions"
					}
				];
				_event.m.Archer1.getBaseProperties().RangedSkill += 1;
				_event.m.Archer1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Maîtrise à Distance"
				});
				_event.m.Archer2.getBaseProperties().RangedSkill += 1;
				_event.m.Archer2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Maîtrise à Distance"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]Ayant l\'impression que leurs disputes ne finiront jamais, vous leur donnez le feu vert pour leur petite compétition avant de vous retirer dans votre tente. Peu après, vous entendez les flèches s\'encocher, se détacher et trouver leur cible. Les choses qui font \"thwang\" font bientôt \"thwap\" et l\'air se remplit lentement du vacarme d\'une foule qui regarde. En essayant de vous concentrer, vous remarquez que les hommes tirent avec ardeur depuis un certain temps déjà. Vous sortez de votre tente pour trouver les deux archers en train de se chamailler, chacun pointant un doigt sur l\'autre avant de prendre une flèche et de la lancer rageusement dans le champ de tir. Leurs cibles ne sont même plus des cibles, mais de petits buissons de flèches sur lesquels se brisent tous les tirs qui y tombent. En secouant la tête, vous ordonnez aux deux hommes d\'arrêter immédiatement avant qu\'ils n\'utilisent toutes les flèches de la compagnie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne peux pas vous laisser seuls deux secondes !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.getFlags().increment("ParticipatedInShootingContests", 1);
				_event.m.Archer2.getFlags().increment("ParticipatedInShootingContests", 1);
				this.World.Assets.addAmmo(-60);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-60[/color] Munitions"
					}
				];
				_event.m.Archer1.getBaseProperties().Bravery += 1;
				_event.m.Archer1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Archer1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
				});
				_event.m.Archer2.getBaseProperties().Bravery += 1;
				_event.m.Archer2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Archer2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "Vous secouez la tête pour dire non, car les réserves sont bien trop faibles pour s\'adonner à un tel comportement. Les hommes soupirent et s\'éloignent, continuant à se disputer longuement et bruyamment au loin.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il y a des choses plus importantes à faire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.worsenMood(1.0, "On lui a refusé une demande");

				if (_event.m.Archer1.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer1.getMoodState()],
						text = _event.m.Archer1.getName() + this.Const.MoodStateEvent[_event.m.Archer1.getMoodState()]
					});
				}

				_event.m.Archer2.worsenMood(1.0, "On lui a refusé une demande");

				if (_event.m.Archer2.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer2.getMoodState()],
						text = _event.m.Archer2.getName() + this.Const.MoodStateEvent[_event.m.Archer2.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getAmmo() <= 80)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.bowyer")
			{
				if (!bro.getFlags().has("ParticipatedInShootingContests") || bro.getFlags().get("ParticipatedInShootingContests") < 3)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Archer1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Archer2 = null;
		this.m.Score = candidates.len() * 5;

		do
		{
			this.m.Archer2 = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		while (this.m.Archer2 == null || this.m.Archer2.getID() == this.m.Archer1.getID());
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"archer1",
			this.m.Archer1.getName()
		]);
		_vars.push([
			"archer2",
			this.m.Archer2.getName()
		]);
	}

	function onClear()
	{
		this.m.Archer1 = null;
		this.m.Archer2 = null;
	}

});

