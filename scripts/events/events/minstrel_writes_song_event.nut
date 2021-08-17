this.minstrel_writes_song_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		OtherBrother = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_writes_song";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%minstrel% le ménestrel prend un luth. Vous n\'avez aucune idée de l\'endroit où il a trouvé l\'instrument, mais il donne quelques coups aux cordes, attirant l\'attention du reste de la compagnie. Il prend sa tête, les yeux fermés, et commence à chanter. %SPEECH_ON%I... -strum- j\'ai rejoint une bande de mercenaires, mes coffres sont vides... -strum-... ils voulaient un combattant, mais tout ce que j\'avais c\'était des chansons. Fin.%SPEECH_OFF%La compagnie rit quand l\'idiot jette le luth sur son épaule. | %minstrel% le ménestrel fait apparaître un luth comme un magicien le ferait avec un lapin. Il le gratte un peu, puis se met à chanter. %SPEECH_ON%Il était une fois un monstre qui terrorisait la foire de Riggabong... -strum-... Ils l\'appelaient, si je me souviens bien, un vrai problème... -strum strum-...\n\nCette bête ne pouvait se régaler que des dames, mais seulement des vierges oh oui elles avaient bon goût !...-strum strum-... mais évidemment ce n\'était pas, pour l\'homme ou la femme, un destin désiré !... -sketchy strum-, un nouveau-...\n\nAlors ils ont engagé Sir Galicock, le plus grand épéiste du pays...-strum-...et il est allé de porte en porte, et a vaincu toutes les vierges qu\'un bon épéiste peut !...-strum-... et le monstre est mort de faim. La fin.%SPEECH_OFF% | Alors qu\'un feu crépite et que les hommes commencent à avoir les yeux fatigués devant sa flamme, %minstrel% le ménestrel s\'éclaircit la gorge d\'une manière qui se décrit le mieux comme \"tout le monde écoute\". Il se met debout, lui aussi, et lève la main comme si elle portait un verre pour porter un toast.%SPEECH_ON%Aye, vous êtes parmi les meilleurs hommes que j\'ai jamais rencontrés. Je dis ça parce que je n\'ai jamais connu mon père et que j\'ai passé toutes mes années avec des femmes.%SPEECH_OFF%Il regarde longuement au loin.%SPEECH_ON%Mon Dieu, j\'ai été avec beaucoup de femmes.%SPEECH_OFF%Et puis il s\'assied. Un moment de silence s\'installe dans l\'air avant d\'être brisé par des éclats de rire. | %minstrel% le ménestrel est à la recherche de son luth. Ne le trouvant pas, il a recours à un \"air lute\" à la place, en jouant avec son pouce.%SPEECH_ON%Attendez, ça ne sonne pas tout à fait bien, laissez-moi l\'accorder.%SPEECH_OFF%Il lève la main et tourne son doigt, puis recommence à gratter.%SPEECH_ON%Quoi ? C\'était pire que la première fois. Il essaie à nouveau, mais apparemment ce \"strum\" n\'était pas bon non plus.%SPEECH_ON% Au diable ce morceau de merde!%SPEECH_OFF% Le ménestrel se lève d\'un bond et écrase à plusieurs reprises le luth invisible contre le sol avant de le jeter dans les hautes herbes. Il balaie la sueur de son front. %SPEECH_ON%Vous aviez raison, cher père, j\'aurais dû être forgeron.%SPEECH_OFF%Et puis il part en trombe, les rires confus de la compagnie crépitant derrière lui. | Tout en jetant de la terre dans le feu, %minstrel% le ménestrel commence à parler, à qui personne ne peut être sûr.%SPEECH_ON%Les vieux dieux ont dit que la lumière soit, n\'est-ce pas ? C\'est la première chose qu\'ils ont faite, donc clairement la lumière doit être importante.%SPEECH_OFF% Il ramasse un morceau de terre et semble l\'analyser.%SPEECH_ON%Alors pourquoi y a-t-il tant de plaisir à trouver là où une femme est la plus sombre?%SPEECH_OFF%Les spectateurs d\'abord confus éclatent de rire. | %minstrel% le ménestrel se lève et fait claquer ses bottes. %SPEECH_ON%Je vous montre comment danser, bande d\'idiots ?%SPEECH_OFF% Quelques hommes lèvent les yeux et secouent la tête. %SPEECH_ON%C\'est simple. Regardez. %SPEECH_OFF%L\'homme lève une jambe, elle fait un angle qu\'aucune jambe d\'homme ne devrait faire avant de se planter à nouveau sur le sol. Il tourne sur lui-même, les bras au-dessus de sa tête. Puis il déploie ses bras comme s\'il voulait voler. Il est en fait assez beau, bien que vous ne l\'admetterez jamais à quiconque. Vous regardez le ménestrel continuer, penché en avant, quand soudain il émet un pet horrible en plein dans le visage d\'un autre mercenarie. Le ménestrel se redresse en un instant, comme si le gaz avait réparé un mal de dos et qu\'il cherchait à se débarasser. %SPEECH_ON%Je... hum... j\'espère que vous avez bien compris les mouvements!%SPEECH_OFF%Il s\'enfuit, un homme particulièrement vexé et malodorant sur ses talons. Les autres hommes sont pris d\'un fou rire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bravo!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Minstrel.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "S\'est senti amusé");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_minstrel = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_minstrel.len() == 0)
		{
			return;
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.OtherBrother = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates_minstrel.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.OtherBrother.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.OtherBrother = null;
	}

});

