this.dead_bodies_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.dead_bodies_in_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img] {Alors que vous marchez dans la forêt, %randombrother% appelle la compagnie. Vous regardez pour le voir pointer du doigt quelque part au-delà d\'une ligne de broussailles. Quand vous marchez vers lui, vous voyez ce qu\'il voit : trois corps suspendus à un arbre. Leurs visages empourprés et leurs pieds gris se balancent et se tournent, le vent les forçant parfois à se faire face. %randombrother% note qu\'ils portent des panneaux: signes de leurs crimes. \"Voleur\", lit-on sur l\'un d\'eux. \"Pute\" un autre. \"Traître\" le dernier. Ayant assez vu, vous dites aux hommes de se remettre en route. | La forêt n\'offre aucun répit, aucune petite route ou chemin de traverse que vous pourriez emprunter. Elle est épaisse et implacable et ne semble pas vouloir de vous. Vous découvrez bientôt qu\'elle n\'a pas voulu de quelqu\'un d\'autre non plus : un cadavre est trouvé attaché dans un buisson d\'épines, les jambes tordues, les bras pliés, le tout plutôt arrangé pour atteindre son but supposé. La bouche reste ouverte, les yeux bridés dans une sorte de frustration finale. %randombrother% vous rattrape, regarde le corps de haut en bas, puis hoche la tête.%SPEECH_ON%Le corps est propre comme un sou neuf, à part les coupures des épines bien sûr. Je dirais que cet homme était tellement perdu qu\'aucun animal ne pouvait le trouver. Il est mort, sans utilité pour personne ou quoi que ce soit.%SPEECH_OFF%Vous montrez du doigt une fourmi qui s\'agite sans réfléchir autour des dents de l\'homme mort. Le frère rit et secoue la tête.%SPEECH_ON%Vous êtes sûr qu\'il n\'est pas perdu aussi ?%SPEECH_OFF% | Vous fixez la canopée de la forêt, en observant les angles sous lesquels les rayons lumineux arrivent. Alors que vous prenez vos repères, %randombrother% arrive, l\'air plutôt désemparé.%SPEECH_ON%Monsieur, vous devriez venir voir ça.%SPEECH_OFF%Vous acquiescez et lui dites de vous montrer le chemin. Il vous amène à une clairière, bien que peu de choses soient claires.\n\nDes jambes. Des jambes partout. Certaines coupées à la cheville, d\'autres à la cuisse, et partout ailleurs entre les deux. Elles n\'ont pas de place, pas d\'ordre. Elles sont à peu près toutes là, certaines seules et d\'autres toutes tordues en grappes, certaines plantées debout avec des bâtons comme si elles étaient des blagues ambulantes et quelques-unes semblent même avoir été jetées dans les arbres où elles reposent mollement sur les branches ou à l\'envers par les pieds. L\'une d\'entre elles est suspendue à une broche, le mollet brûlé noir comme si quelqu\'un s\'était enfui, l\'abandonnant là sur un feu mort depuis longtemps.\n\nLe frère qui a découvert le spectacle dégoûtant vient se placer à côté de vous.%SPEECH_ON%Pas de corps, monsieur. Juste... des jambes.%SPEECH_OFF%Vous vous retournez pour regarder le mercenaire, mais il ne peut que hausser les épaules.%SPEECH_ON%Nous n\'avons pas trouvé un seul corps, monsieur. Je veux dire, la moitié supérieure, en tout cas. Pensez-vous que cela signifie quelque chose ? Je veux dire, qui ferait ça ? Enlever les jambes de quelqu\'un et ensuite partir avec le reste ?%SPEECH_OFF%Vous secouez la tête en signe d\'incrédulité. Ayant vu assez de choses, et n\'ayant pas de réponse à de telles questions, vous éloignez rapidement le reste des hommes de la clairière et vous vous remettez en marche. | Vous vous arrêtez au bord d\'un ruisseau pour vous laver et prenez quelque chose à boire, mais avant que vous ne preniez la première gorgée, %randombrother% vous attrape l\'épaule. Il vous montre du doigt l\'amont de la rivière. Le corps d\'une femme est face au sol dans l\'eau, ses longs cheveux se tordant de façon assez vive au gré des ondulations. Vous remerciez le mercenaire de vous avoir sauvé de toute maladie que les morts répandent sur le monde. | La canopée des arbres est épaisse et tortueuse. Le peu de lumière qu\'il y a au-dessus peut à peine passer, des tresses d\'ombre entourant vos hommes alors qu\'ils marchent. Mais plus loin, vous voyez un pilier de lumière qui brille dans la forêt. Naturellement, quelqu\'un d\'autre l\'a vu en premier. Et c\'est la dernière chose qu\'ils ont vue.\n\nDans ce trait de lumière, un garçon se repose, dos contre un arbre. Sa tête est alignée et ses mains sont tournées vers le haut et ouvertes. Des taches violettes maculent ses paumes. %randombrother% s\'approche et secoue immédiatement la tête.%SPEECH_ON%Des baies empoisonnées. Ce satané gamin n\'avait aucune chance.%SPEECH_OFF%Vous vous tournez vers votre frère d\'armes et lui demandez si le garçon aurait pu partir paisiblement. L\'homme secoue à nouveau la tête. %SPEECH_ON%Non.%SPEECH_OFF% | Un corps mort. Ou plutôt, ce qui devrait être un corps. La poitrine est ouverte et les viscères étalés dans toutes les directions, grises, flasques et molles. Vous ne pouvez pas dire s\'il s\'agit d\'un homme ou d\'une femme, seulement qu\'il doit s\'agir d\'un adulte réduit en plusieurs morceaux plus petits. Vous ne savez pas quelle créature a pu faire cela, mais %randombrother% suggère que c\'est peut-être l\'acte d\'un homme très déterminé. | Vous trouvez le corps d\'une femme, le dos appuyé contre un arbre. Il y a un couteau dans sa poitrine, la blessure a été rapidement fatale qu\'elle semble être morte alors qu\'elle était dans un certain mouvement de vie. Au-dessus d\'elle, une autre femme se balance d\'une branche. Ses vêtements sont rouges. La tête du cadavre est inclinée vers l\'avant, comme pour contempler son crime, et la corde qui la suspend gémit sous l\'effet d\'un vent sourd. | Vous tombez sur une scène de bataille. Des hommes, des armures, des armes, pas une seule d\'entre elles n\'est utilisable. Les morts en sont arrivés là par une forme de brutalité pure que vous ne souhaitez pas apprendre. Des empreintes de pas dans la terre suggèrent que quelque chose de gros est passé, laissant derrière lui un sillage de ruines et de calamités, et aucune envie de votre part de suivre ces traces. | En marchant, vous trouvez un homme mort avec quelques flèches cassées dans le dos. D\'autres plaies perforantes où son assassin a réussi à récupérer ses munitions en un seul morceau. L\'homme portait une lettre d\'amour, dont la destination était une femme qui, apparemment, avait déjà été choisie. Ah, la romance.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reposez en paix.",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			if (s.getTile().getDistanceTo(myTile) <= 6)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

