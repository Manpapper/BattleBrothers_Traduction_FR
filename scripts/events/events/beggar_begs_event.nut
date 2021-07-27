this.beggar_begs_event <- this.inherit("scripts/events/event", {
	m = {
		Beggar = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.beggar_begs";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Alors que vous faites le point sur l\'inventaire, vous ne pouvez vous empêcher de remarquer que %beggar% traîne autour de vous. En soupirant, vous vous tournez finalement vers l\'ancien mendiant et lui demandez ce qu\'il veut. Comme le plus pauvre des pauvres, il vous tend la main, vous demandant si vous pouvez vous passer de quelques couronnes. | Avec un sens du théâtre bien rodé, %beggar% s\'approche de vous et vous raconte une longue histoire de problèmes, de querelles et de bouteilles vides. L\'ancien mendiant n\'a apparemment pas de chance et a juste besoin de quelques couronnes supplémentaires pour s\'en sortir. | %otherguy% vous dit que %beggar% fait le tour du camp pour demander des couronnes. Apparemment, l\'ancien mendiant a juste besoin d\'un peu plus, exprimant une longue histoire de pleurs à qui veut bien l\'entendre. En entendant cette nouvelle, vous allez voir l\'homme vous-même, mais avant même que vous ne puissiez prononcer un mot, l\'homme lâche son long récit. Fini, il vous regarde dans les yeux, essayant de jauger si oui ou non vous allez lui donner quelque chose. | Apparemment, %beggar% l\'ancien mendiant a besoin d\'aide. Il est venu vous voir, vous demandant quelques couronnes pour l\'aider à s\'en sortir. L\'homme a l\'air d\'être dans un état de pauvreté, mais comme il a l\'habitude d\'être pauvre, il est difficile de dire si l\'homme est honnête ou non.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retourne au travail!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Tiens, prends quelques couronnes.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous dites au mendiant que vous allez lui couper les mains avec une épée s\'il ne se remet pas au travail. L\'homme hausse les épaules et fait à peu près ce qu\'on lui dit. C\'était plus facile que prévu. | Les épaules du mendiant s\'affaissent alors que vous lui dites de se remettre au travail. Vous vous sentez un peu mal, mais vous vous rappelez que c\'est comme ça qu\'on vous gagne..}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ok.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Le mendiant prend les couronnes et, avec un sourire, se remet au travail. | Fatigué de ses jeux, vous donnez au mendiant quelques couronnes et lui dites de se remettre au travail. Il s\'incline, vous remercie et, étonnamment, se remet au travail.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ok.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
				this.World.Assets.addMoney(-10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]10[/color] Couronnes"
				});
				_event.m.Beggar.improveMood(0.5, "Avoir quelques couronnes supplémentaires de votre part");

				if (_event.m.Beggar.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Beggar.getMoodState()],
						text = _event.m.Beggar.getName() + this.Const.MoodStateEvent[_event.m.Beggar.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beggar")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Beggar = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;

		do
		{
			local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

			if (bro.getID() != this.m.Beggar.getID())
			{
				this.m.OtherGuy = bro;
			}
		}
		while (this.m.OtherGuy == null);
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beggar",
			this.m.Beggar.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Beggar = null;
		this.m.OtherGuy = null;
	}

});

