this.alp_nightmare1_event <- this.inherit("scripts/events/event", {
	m = {
		Victim = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.alp_nightmare1";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 300.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Les hommes discutent autour du feu de camp quand %spiderbro% se lève soudainement en hurlant. Il bondit en arrière, et éclairé par les flammes, on voit une araignée de la taille d'un casque collée à sa botte!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que quelqu'un la découpe!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Brûlez-la dans le feu!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Vous dégainez votre lame, mais %otherbro% vous a déjà devancé. Il crie à %spiderbro% de rester immobile, ce qu\'il fait à contrecœur. Mais le mercenaire armé balance sa lame bien trop haut et coupe directement le cou de l\'homme. Le corps sans tête s\'effondre et le reste de la compagnie hurle de peur et de rage.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est quoi ce bordel!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Victim.getName() + " est mort"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Vous courez vers %otherbro% pour l\'étrangler, mais vos mains passent à travers la chair comme des doigts dans le brouillard et votre élan vous envoie au sol.%SPEECH_ON%Euh, vous allez bien capitaine?%SPEECH_OFF%En regardant en arrière, vous voyez un %spiderbro% en parfaite santé assis à côté du feu. Au loin, quelque chose de pâle et de fin s\'éloigne d\'un tronc d\'arbre. Quand vous clignez des yeux, il n\'y a plus rien. Vous dites aux hommes de surveiller le périmètre et retournez à votre tente en secouant la tête et en vous frottant les yeux.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Juste un mauvais rêve.",
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%spiderbro% hoche la tête et se dirige d\'un pas ferme vers le feu de camp, l\'araignée le regardant avec des yeux étrangement confiants. Il met la créature dans le feu et celle-ci s\'enflamme immédiatement. Au début, vous pensez qu\'il a réussi, qu\'il est hors de danger, mais l\'araignée ardente s\'élance le long de la jambe du pantalon de l\'homme, enflammant sa tenue, se collant à sa tête. En proie aux flammes, l\'homme jette ses mains en l\'air et commence à courir dans tous les sens pour demander de l\'aide. La bête enfonce ses crocs dans son crâne et les hurlements cessent dans une paralysie soudaine et le soldat tombe dans le feu de camp comme une planche de bois.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sortez son corps de là!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Victim.getName() + " est mort"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Vous hurlez aux mercenaires de faire leur part, mais quand vous sautez vers %spiderbro%, il y a un jet de braises et d\'étincelles qui vous arrête. Quand elles s\'estompent, vous trouvez le mercenaire calmement assis à côté des flammes.%SPEECH_ON%Ah, capitaine, vous avez dit quelque chose ?%SPEECH_OFF%En regardant autour de vous, vous trouvez le reste de la compagnie en train de bavarder. Lorsque vous vous retournez vers %spiderbro%, vous pensez voir une ombre blanche passer derrière lui, mais en y regardant une seconde fois, elle a disparu. Vous dites aux hommes de garder un œil vigilant sur d\'éventuelles intrusions, puis vous retournez à votre tente.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'ai besoin de plus de repos.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( i, bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				brothers.remove(i);
				break;
			}
		}

		if (brothers.len() < 3)
		{
			return;
		}

		this.m.Victim = brothers[this.Math.rand(0, brothers.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Victim.getID())
			{
				other_candidates.push(bro);
			}
		}

		this.m.Other = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"spiderbro",
			this.m.Victim.getName()
		]);
		_vars.push([
			"otherbro",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Victim = null;
		this.m.Other = null;
	}

});

