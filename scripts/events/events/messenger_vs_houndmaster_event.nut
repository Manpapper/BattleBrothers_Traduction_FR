this.messenger_vs_houndmaster_event <- this.inherit("scripts/events/event", {
	m = {
		Messenger = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.messenger_vs_houndmaster";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%messenger% and %houndmaster% partagent des histoires autour d\'un feu de camp. Le messager rit.%SPEECH_ON%Laisse moi te parler de ma première livraison. J\'ai marché jusqu\'à ce donjon qui avait de belles douves. Les choses les plus dangereuses dans l\'eau étaient les nénuphars et les grenouilles gonflées par les mouches. J\'ai traversé le pont-levis et suis entrée, une lettre à la main, le ventre gonflé d\'excitation. Je suis entré et qu\'est-ce que j\'ai entendu ? Roo-roo-roo-roo ! Ruh-ruh-ruh ! Ce putain de bâtard sort en trombe de sa niche, les dents pointues, les oreilles dressées. Je me dis \"oh merde, je n\'ai pas signé pour ça et j\'escalade un poulailler pendant que cette bête à fourrure essaie de me manger les pieds\". Finalement, le seigneur sort et le chien s\'assied comme s\'il n\'avait rien fait du tout. Le noble rit et prend la lettre que je suis venu lui remettre. Il dit : \"Quoi, vous n\'avez pas vu le panneau ?\" J\'ai dit : \"Euh, non monsieur, mais je vais y aller maintenant\". Quand je suis parti, ils ont remonté le pont-levis et comme par hasard, sur le dessous, ils avaient peint ce gros avertissement \"Attention au chien\"!%SPEECH_OFF%%houndmaster% éclate de rire.%SPEECH_ON% Pour un premier jour de travail, ce n\'est pas si mal. Mais sachez qu\'aucun chien de %companyname% ne vous fera de mal ! Je vais dresser ces bâtards comme il faut !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Malheur au facteur.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Messenger.getImagePath());
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				_event.m.Messenger.improveMood(1.0, "S\'est lié avec " + _event.m.Houndmaster.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Messenger.getMoodState()],
					text = _event.m.Messenger.getName() + this.Const.MoodStateEvent[_event.m.Messenger.getMoodState()]
				});
				_event.m.Houndmaster.improveMood(1.0, "S\'est lié avec " + _event.m.Messenger.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Houndmaster.getMoodState()],
					text = _event.m.Houndmaster.getName() + this.Const.MoodStateEvent[_event.m.Houndmaster.getMoodState()]
				});
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

		local messenger_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.messenger")
			{
				messenger_candidates.push(bro);
			}
		}

		if (messenger_candidates.len() == 0)
		{
			return;
		}

		local houndmaster_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				houndmaster_candidates.push(bro);
			}
		}

		if (houndmaster_candidates.len() == 0)
		{
			return;
		}

		this.m.Messenger = messenger_candidates[this.Math.rand(0, messenger_candidates.len() - 1)];
		this.m.Houndmaster = houndmaster_candidates[this.Math.rand(0, houndmaster_candidates.len() - 1)];
		this.m.Score = (messenger_candidates.len() + houndmaster_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"messenger",
			this.m.Messenger.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Messenger = null;
		this.m.Houndmaster = null;
	}

});

