this.bowyer_crafts_masterwork_event <- this.inherit("scripts/events/event", {
	m = {
		Bowyer = null,
		OtherGuy1 = null,
		OtherGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.bowyer_crafts_masterwork";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%bowyer% le fabricant d'arc vient vous voir avec une petite requête : il souhaite construire une arme depuis des années. Apparemment, l'homme a tenté de construire un arc légendaire pendant de nombreuses années, mais maintenant qu'il est sur la route, il a appris quelques trucs pour combler ses lacunes. En vérité, il croit qu'il peut réussir cette fois-ci. Tout ce dont il a besoin, c'est de quelques ressources pour l'aider à se procurer les éléments nécessaires à sa construction. Une somme de 500 couronnes qu'il demande humblement, et le bois de qualité que vous transportez.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Construisez-moi un arc de légendes!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "Nous n'avons pas le temps pour ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{L'arc n'est pas légendaire, mais il est très bien. C'est léger dans la prise en main, facile à faire tourner d'un côté à l'autre avec l'air qui siffle quand il tourbillonne. Vous essayez de tirer sur la corde. Un homme fort sera nécessaire pour le manier, c'est certain. Lorsque vous décochez une flèche, le manche se déplace de façon incroyablement droite et le tir semble presque se faire tout seul. Une arme brillante si vous en avez jamais vu une! | L'arc a été construit avec un mélange de bois dont vous ne connaissez pas le nom. Des couleurs de tel ou tel arbre s'enroulent le long l'arme, donnant l'impression d'un damasquinage arborescent. En testant la corde vous remarquez qu'elle s'avère puissante. Tu n'es pas un tireur d'élite, mais quand tu lâches une flèche, elle semble presque se guider toute seule vers sa cible. Une arme formidable, ne serait-ce que parce qu'elle vous fait paraître meilleur que vous ne l'êtes vraiment. Vous félicitez fabricant d'arc.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un chef d'oeuvre!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Courrones"
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.quality_wood")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/weapons/masterwork_bow");
				item.m.Name = item.m.Name + " de " + _event.m.Bowyer.getNameOnly();
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				_event.m.Bowyer.improveMood(2.0, "A créé un chef d'oeuvre");

				if (_event.m.Bowyer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Est-ce que ce truc est une expérience ? Le bois craque et se fissure lorsqu'on le plie, la corde s'effiloche et se déforme à chaque fois qu'on la tire, et on jurerait avoir vu une termite sortir sa tête de l'arc. Toutes les flèches que vous avez envoyés sont presque partis à l'opposé d'où vous le souhaitiez, elles vont de-ci de-là, n'importe où, sauf sur la cible supposée.\n\nVous soulagez la douleur du fabricant d'arc en vous rendant responsable de l'imprécision de l'arme, mais %otherguy1% et %otherguy2% s'y essaient et obtiennent des résultats encore pires. Le fabricant d'arc finit par s'éloigner, en prenant sa création dans ses bras avant de la jeter sur la pile d'armes où l'on aimerait qu'elle ressemble à n'importe quel autre arc, mais sa laideur obscène la fait ressortir comme un charbon chaud sur une botte de foin. Il est certain qu'aucun homme ne maniera cette chose par accident!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je comprends maintenant pourquoi tu ne travailles plus comme fabriquant d'arc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Couronnes"
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.quality_wood")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/weapons/wonky_bow");
				item.m.Name = item.m.Name + " de " +_event.m.Bowyer.getNameOnly();
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				_event.m.Bowyer.worsenMood(1.0, "N'a pas réussi à créer un chef d'oeuvre");

				if (_event.m.Bowyer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous dites au fabriquant d'arc que %companyname% n'a pas de ressources supplémentaire à disposition. L'homme grince des dents, et apparemment retiens les mots qu'il avait à dire, car il ne dit rien et tourne les talons et s'en va. Au loin, vous entendez enfin la gentillesse qu'il vous réservait - une litanie de jurons et d'injures et finalement des gémissements de déception.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ressaisis-toi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				_event.m.Bowyer.worsenMood(2.0, "Une demande a été refusée");

				if (_event.m.Bowyer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 2000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.bowyer")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numWood = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.quality_wood")
			{
				numWood = ++numWood;
				break;
			}
		}

		if (numWood == 0)
		{
			return;
		}

		this.m.Bowyer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 4;
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Bowyer.getID())
			{
				this.m.OtherGuy1 = bro;
				break;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Bowyer.getID() && bro.getID() != this.m.OtherGuy1.getID())
			{
				this.m.OtherGuy2 = bro;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bowyer",
			this.m.Bowyer.getNameOnly()
		]);
		_vars.push([
			"otherguy1",
			this.m.OtherGuy1.getName()
		]);
		_vars.push([
			"otherguy2",
			this.m.OtherGuy2.getName()
		]);
	}

	function onClear()
	{
		this.m.Bowyer = null;
		this.m.OtherGuy1 = null;
		this.m.OtherGuy2 = null;
	}

});

